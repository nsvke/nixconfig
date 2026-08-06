{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=11";
        dpi-aware = "auto";
        icons-enabled = "yes";
        fields = "filename,name,generic";
        password-character = "*";
        show-actions = "yes";
        prompt = ">  ";

        anchor = "center";
        lines = 10;
        width = 40;
        tabs = 4;
        horizontal-pad = 25;
        vertical-pad = 20;
        inner-pad = 10;
        image-size-ratio = 0.5;

        layer = "overlay";
        exit-on-keyboard-focus-loss = "yes";

      };
      colors = {
        background = "1e1e2eaa";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "f38ba8ff";
        border = "89b4faff";
      };
      border = {
        width = 2;
        radius = 0;
      };
      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };
}
