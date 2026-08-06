{ pkgs, ... }:
{
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        glib
      ];
    };
    fish.enable = true;
    vim.enable = true;
    niri.enable = true;

    steam.enable = true;
    gamemode.enable = true;

    appimage.enable = true;

  };

  environment.systemPackages = with pkgs; [
    curl
    wget
  ];
}
