{ pkgs, ... }:
{
  systemd.user.services.fup = {
    Unit = {
      Description = "Auto update flake.lock";
      StartLimitIntervalSec = "7200";
      StartLimitBurst = 3;
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "fup-runner" "fup"}";
      StandardOutput = "journal";
      StandardError = "journal";
      Restart = "on-failure";
      RestartPreventExitStatus = "2";
      RestartSec = "1800";
      KillSignal = "SIGINT";
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
