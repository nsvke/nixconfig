{ ... }:
{
  imports = [
    ./dunst.nix
  ];

  services = {
    playerctld.enable = true;
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "niri msg action power-off-monitors";
        }
      ];
    };
    udiskie.enable = true;
    cliphist.enable = true;
  };
}
