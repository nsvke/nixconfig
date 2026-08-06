{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;

    plymouth.enable = true;
    initrd.systemd.enable = true;

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "systemd.show_status=auto"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
    ];

    tmp.useTmpfs = true;
  };
}
