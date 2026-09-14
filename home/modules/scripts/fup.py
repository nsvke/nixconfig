import argparse
import getpass
import json
import re
import socket
import subprocess
from dataclasses import dataclass
from enum import Enum
from sys import exit
from typing import cast

flake_dir = "@flakeDir@"
# flake_dir = "/home/enes/.config/nixos/"


@dataclass
class Args(argparse.Namespace):
    verbose: bool = False
    ignore_dirty: bool = False
    ignore_internet: bool = False


fup_args = Args()


class Status(Enum):
    OK = 0
    ERR = 1
    STOP = 2
    DEFER = 3

    def is_ok(self):
        return self == Status.OK

    def is_err(self):
        return self == Status.ERR

    def is_stop(self):
        return self == Status.STOP

    def is_defer(self):
        return self == Status.DEFER

    def exitcode(self):
        if self.is_ok() or self.is_stop():
            return 0
        elif self.is_defer():
            return 1
        return 2


def log(text: str) -> None:
    print("fup: " + text)


def run(
    cmd: list[str],
    cwd: str | None = None,
    input: str | None = None,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        cmd,
        cwd=cwd,
        input=input,
        capture_output=True,
        text=True,
        check=False,
    )

    if fup_args.verbose:
        print(f"[RUN] {' '.join(cmd)}")
        if result.stdout:
            print(result.stdout, end="")
        if result.stderr:
            print(result.stderr, end="")

    return result


def notify(text: str) -> None:
    if run(["notify-send", "-u", "normal", "Fup", text]).returncode != 0:
        log("notify failed")


def rollback(notification: str) -> None:
    _ = run(
        ["git", "checkout", "flake.lock"],
        cwd=flake_dir,
    )
    log("flake rollback")
    if notification:
        notify(notification)


def check_dirty(ignore: bool = False) -> Status:
    if (
        run(
            ["git", "status", "--porcelain"],
            cwd=flake_dir,
        ).stdout.strip()
        and not ignore
    ):
        log("repo is dirty")
        return Status.STOP

    return Status.OK


def check_internet(ignore: bool = False) -> Status:
    if (
        run(["ping", "-q", "-c", "1", "-W", "1", "1.1.1.1"]).returncode != 0
    ) and not ignore:
        log("network is unreachable")
        return Status.DEFER
    return Status.OK


def update() -> Status:
    flake_update = run(
        ["nix", "flake", "update"],
        cwd=flake_dir,
    )

    if flake_update.returncode != 0:
        log("update failed")
        return Status.ERR

    if (
        run(
            ["git", "diff", "--quiet", "flake.lock"],
            cwd=flake_dir,
        ).returncode
        == 0
    ):
        log("flake already up to date")
        return Status.STOP

    return Status.OK


def dry_build_and_check() -> Status:
    flake_dry_build = run(
        [
            "nix",
            "build",
            "--dry-run",
            f".#nixosConfigurations.{socket.gethostname()}.config.system.build.toplevel",
            f".#homeConfigurations.{getpass.getuser()}@{socket.gethostname()}.activationPackage",
        ],
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

    hnet_result = run(["hnet", "status", "eth"]).stdout

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
        )
        if fuzzel_res.stdout.strip() != "y":
            log("update rejected manually")
            rollback("update aborted")
            return Status.STOP

    return Status.OK


def build() -> Status:
    flake_build = run(
        [
            "nix",
            "build",
            "--no-link",
            f".#nixosConfigurations.{socket.gethostname()}.config.system.build.toplevel",
            f".#homeConfigurations.{getpass.getuser()}@{socket.gethostname()}.activationPackage",
        ],
        cwd=flake_dir,
    )

    if flake_build.returncode != 0:
        log("build failed")
        rollback("build failed")
        return Status.ERR

    return Status.OK


def commit() -> Status:
    old_raw = run(
        ["git", "show", "HEAD:flake.lock"],
        cwd=flake_dir,
    )
    updated_inputs = ""

    if old_raw.returncode == 0:
        old_lock = cast(dict[str, object], json.loads(old_raw.stdout))
        with open(f"{flake_dir}/flake.lock", "r") as f:
            new_lock = cast(dict[str, object], json.load(f))

        old_nodes = cast(dict[str, object], old_lock.get("nodes", {}))
        new_nodes = cast(dict[str, object], new_lock.get("nodes", {}))
        root_node = new_lock.get("root")

        for name, data_obj in new_nodes.items():
            if name == root_node:
                continue
            data = cast(dict[str, object], data_obj)

            old_node = cast(dict[str, object], old_nodes.get(name, {}))

            old_locked = cast(dict[str, object], old_node.get("locked", {}))
            new_locked = cast(dict[str, object], data.get("locked", {}))

            old_rev = old_locked.get("rev")
            new_rev = new_locked.get("rev")

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
        cwd=flake_dir,
    )

    if flake_commit.returncode != 0:
        log("commit failed")
        rollback("update failed!")
        return Status.ERR

    return Status.OK


def push() -> Status:
    flake_push = run(
        ["git", "push", "origin", "main"],
        cwd=flake_dir,
    )

    if flake_push.returncode == 0:
        notify("update successfull")
        return Status.OK
    else:
        notify("uptade completed but couldn't pushed")
        return Status.ERR


def set_args() -> None:
    parser = argparse.ArgumentParser(prog="fup", description="Fup: Flake Auto-Updater")
    _ = parser.add_argument("-v", "--verbose", action="store_true")
    _ = parser.add_argument("-d", "--ignore-dirty", action="store_true")
    _ = parser.add_argument("-i", "--ignore-internet", action="store_true")
    args = parser.parse_args(namespace=Args())

    fup_args.verbose = args.verbose
    fup_args.ignore_dirty = args.ignore_dirty
    fup_args.ignore_internet = args.ignore_internet


def apply(status: Status):
    if not status.is_ok():
        exit(status.exitcode())


def main():
    set_args()

    apply(check_internet(fup_args.ignore_internet))
    apply(check_dirty(fup_args.ignore_dirty))
    apply(update())
    apply(dry_build_and_check())
    apply(build())
    apply(commit())
    apply(push())


if __name__ == "__main__":
    main()
