{ ... }:
{
  imports = [
    ./dunst.nix
  ];

  services = {
    cliphist.enable = true;

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

    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };
}
