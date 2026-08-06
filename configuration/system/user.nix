{ pkgs, ... }:
{
  users.users.enes = {
    isNormalUser = true;
    description = "enes";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "tray"
      "kvm"
      "libvirtd"
      "input"
      "dialout"
    ];
    packages = [ ];
  };
}
