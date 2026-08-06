{ ... }:
{
  imports = [
    ./niri
    ./yazi
    ./atuin.nix
    ./direnv.nix
    ./fish.nix
    ./foot.nix
    ./fuzzel.nix
    ./git.nix
    ./helix.nix
    ./lazygit.nix
    ./quickshell.nix
  ];

  programs = {
    starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      presets = [ "plain-text-symbols" ];
    };
    zoxide.enable = true;

    firefox.enable = true;

    aerc.enable = true;

    gh.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    zed-editor.enable = true;

    ghostty.enable = true;

    mpv.enable = true;

    eza.enable = true;
    bat.enable = true;
    ripgrep.enable = true;

    rbw.enable = true;

    fd.enable = true;

    btop.enable = true;

    fastfetch.enable = true;

    imv.enable = true;

    zathura.enable = true;
  };
}
