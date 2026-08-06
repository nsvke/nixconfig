{ ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    themes = {
      transparent_custom = {
        inherits = "github_dark";
        "ui.background" = { };
      };
    };
    settings = {
      theme = "transparent_custom";
      editor = {
        line-number = "absolute";
        mouse = true;
        bufferline = "always";
        true-color = true;
        rulers = [ 72 ];
        indent-guides = {
          render = true;
          chracter = "| ";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        search = {
          smart-case = true;
          wrap-around = true;
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
        };
      };
    };
  };
}
