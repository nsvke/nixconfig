{ ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "foot";
        font = "CaskaydiaCove Nerd Font Mono:style=SemiBold:pixelsize=15";
        initial-window-size-chars = "100x30";
        selection-target = "both";
      };
      cursor = {
        style = "underline";
        blink = "no";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors-dark = {
        "alpha" = "0.8";
        "cursor" = "0f0f0f ffff00";
        "background" = "0f0f0f";
        "foreground" = "fefefe";

        ## Normal/Regular Colors
        "regular0" = "1a1a1a";
        "regular1" = "ff4b4b";
        "regular2" = "4dff88";
        "regular3" = "ffe347";
        "regular4" = "4da6ff";
        "regular5" = "c74ded";
        "regular6" = "3cf4f4";
        "regular7" = "f0f0f0";

        ## Bright Colors
        "bright0" = "333333";
        "bright1" = "ff3333";
        "bright2" = "33ff99";
        "bright3" = "fff75a";
        "bright4" = "3399ff";
        "bright5" = "d366ff";
        "bright6" = "56fcfc";
        "bright7" = "ffffff";

        "selection-foreground" = "fefefe";
        "selection-background" = "264f78";
      };
      key-bindings = {
        "clipboard-copy" = "Control+Shift+c XF86Copy";
        "clipboard-paste" = "Control+Shift+v XF86Paste";
        "font-reset" = "Control+0";
      };
    };
  };
}
