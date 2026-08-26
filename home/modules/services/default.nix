{ pkgs, ... }:
{
  imports = [
    ./dunst.nix
    ./fup.nix
  ];

  services = {
    cliphist.enable = true;

    playerctld.enable = true;
    
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        }
      ];
    };

    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };
}
