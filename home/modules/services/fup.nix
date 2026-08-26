{ pkgs, ... }:
{
  systemd.user.services.fup = {
    Unit = {
      Description = "Auto update flake.lock";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "fup-runner" ''fup''}";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  systemd.user.timers.fup = {
    Unit = {
      Description = "Timer for fup";
    };
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
