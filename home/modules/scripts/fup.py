import getpass
import json
import re
import socket
from enum import Enum
from subprocess import run
from sys import exit

flake_dir = "@flakeDir@"
# flake_dir = "/home/enes/.config/nixos/"


class Status(Enum):
    OK = 0
    ERR = 1
    STOP = 2

    def is_ok(self):
        return self == Status.OK

    def is_err(self):
        return self == Status.ERR

    def is_stop(self):
        return self == Status.STOP

    def exitcode(self):
        if self.is_err():
            return 1
        else:
            return 0


def log(text: str):
    print("fup: " + text)


def notify(text: str):
    if (
        run(
            ["notify-send", "-u", "normal", "Fup", text],
            capture_output=True,
            check=False,
        ).returncode
        != 0
    ):
        log("notify failed")


def rollback(notification: str):
    _ = run(
        ["git", "checkout", "flake.lock"],
        capture_output=True,
        check=False,
        cwd=flake_dir,
    )
    log("flake rollback")
    if notification:
        notify(notification)


def check_dirty(ignore: bool = False):
    if run(
        ["git", "status", "--porcelain"],
        capture_output=True,
        text=True,
        check=False,
        cwd=flake_dir,
    ).stdout.strip():
        if not ignore:
            log("repo is dirty. skipping")
            return Status.STOP
        else:
            log("repo is dirty. ignoring")

    return Status.OK


def update():
    flake_update = run(
        ["nix", "flake", "update"],
        capture_output=True,
        text=True,
        check=False,
        cwd=flake_dir,
    )

    if flake_update.returncode != 0:
        log("update failed")
        return Status.ERR

    if (
        run(
            ["git", "diff", "--quiet", "flake.lock"],
            capture_output=True,
            check=False,
            cwd=flake_dir,
        ).returncode
        == 0
    ):
        log("flake already up to date")
        return Status.STOP

    return Status.OK


def dry_build_and_check():
    flake_dry_build = run(
        [
            "nix",
            "build",
            "--dry-run",
            f".#nixosConfigurations.{socket.gethostname()}.config.system.build.toplevel",
            f".#homeConfigurations.{getpass.getuser()}@{socket.gethostname()}.activationPackage",
        ],
        capture_output=True,
        text=True,
        check=False,
        cwd=flake_dir,
    )

    if flake_dry_build.returncode != 0:
        log("flake build failed")
        rollback("update failed!")
        return Status.ERR

    match = re.search(
        r"\(\s*([0-9.]+)\s*([A-Za-z]+)\s+download", flake_dry_build.stderr
    )
    if not match:
        return Status.OK

    val = float(match.group(1))
    unit = match.group(2).upper()

    multipliers = {
        "B": 1,
        "KIB": 1024,
        "MIB": 1024**2,
        "GIB": 1024**3,
        "KB": 1000,
        "MB": 1000**2,
        "GB": 1000**3,
    }
    multiplier = multipliers.get(unit, 1)
    fetch_size = multiplier * val

    hnet_result = run(
        ["hnet", "status", "eth"], capture_output=True, text=True, check=False
    ).stdout

    # TODO: hardcoded metered check, expand this
    metered = False
    if (
        hnet_result.strip() == "connected:enp7s0f4u1"
        or hnet_result.strip() == "connected:enp7s0f3u1"
    ):
        metered = True

    # TODO: add abort count
    if metered and fetch_size > 1024**3:
        mb_size = round(fetch_size / (1024**2), 2)
        fuzzel_prompt = f"fup: {mb_size}MB download (y/n): "
        fuzzel_res = run(
            ["fuzzel", "--dmenu", "--prompt", fuzzel_prompt],
            input="y\nn\n",
            capture_output=True,
            text=True,
            check=False,
        )
        if fuzzel_res.stdout.strip() != "y":
            log("update rejected manually")
            rollback("update aborted")
            return Status.STOP

    return Status.OK


def build():
    flake_build = run(
        [
            "nix",
            "build",
            "--no-link",
            f".#nixosConfigurations.{socket.gethostname()}.config.system.build.toplevel",
            f".#homeConfigurations.{getpass.getuser()}@{socket.gethostname()}.activationPackage",
        ],
        capture_output=True,
        check=False,
        cwd=flake_dir,
    )

    if flake_build.returncode != 0:
        log("build failed")
        rollback("build failed")
        return Status.ERR

    return Status.OK


def commit():
    old_raw = run(
        ["git", "show", "HEAD:flake.lock"],
        capture_output=True,
        text=True,
        cwd=flake_dir,
        check=False,
    )
    updated_inputs = ""

    if old_raw.returncode == 0:
        old_lock = json.loads(old_raw.stdout)
        with open(f"{flake_dir}/flake.lock", "r") as f:
            new_lock = json.load(f)

        old_nodes = old_lock.get("nodes", {})
        new_nodes = new_lock.get("nodes", {})
        root_node = new_lock.get("root")

        for name, data in new_nodes.items():
            if name == root_node:
                continue
            old_node = old_nodes.get(name, {})
            old_rev = old_node.get("locked", {}).get("rev")
            new_rev = data.get("locked", {}).get("rev")

            if old_rev and new_rev and old_rev != new_rev:
                updated_inputs += f"  - {name}\n"

    commit_msg = "lock: auto-update"
    commit_body = ""

    if len(updated_inputs) != 0:
        commit_body += "Updated:\n"
        commit_body += updated_inputs
        commit_body += "\n"
    commit_body += "Automated commit generated by fup."

    flake_commit = run(
        ["git", "commit", "flake.lock", "-m", commit_msg, "-m", commit_body],
        capture_output=True,
        check=False,
        cwd=flake_dir,
    )

    if flake_commit.returncode != 0:
        log("commit failed")
        rollback("update failed!")
        return Status.ERR

    return Status.OK


def push():
    flake_push = run(
        ["git", "push", "origin", "main"],
        capture_output=True,
        check=False,
        cwd=flake_dir,
    )

    if flake_push.returncode == 0:
        notify("update successfull")
        return Status.OK
    else:
        notify("uptade completed but couldn't pushed")
        return Status.ERR


def apply(status: Status):
    if status.is_err() or status.is_stop():
        exit(status.exitcode())


def main():
    apply(check_dirty())
    apply(update())
    apply(dry_build_and_check())
    apply(build())
    apply(commit())
    apply(push())


if __name__ == "__main__":
    main()
