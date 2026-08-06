{ pkgs, ... }:
{
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    udisks2.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --cmd 'niri-session'"; # > /dev/null 2>&1'";
          user = "greeter";
        };
      };
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    soteria.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
  };
}
