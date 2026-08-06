{ pkgs, ... }:
{
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  xdg.icons.fallbackCursorThemes = [ "Bibata-Modern-Ice" ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [
        "nerd-fonts.fira-code"
        "nerd-fonts.fira-code"
      ];
    };
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code-symbols
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-cove
      corefonts
    ];
  };
}
