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

  environment.etc."vimrc".text = ''
      syntax on
      set number
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set ignorecase
      set smartcase
      set autoindent
      set whichwrap+=<,>,[,]
      set incsearch
      set hlsearch
      set laststatus=2
      set mouse=a
      set undolevels=1000
      set showcmd
      set ruler
    '';
}
