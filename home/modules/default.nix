{ pkgs, ... }:
let
  home-scripts = pkgs.callPackage ./scripts { };
in
{
  imports = [
    ./programs
    ./services
  ];

  home.packages = with pkgs; [
    home-scripts
    nixd
    nil
    dante
    tldr
    xwayland-satellite
    clang-tools
    gocryptfs
    psmisc
    bibata-cursors
    mdcat
    cbonsai
    gdu
    duf
    scrcpy
    android-tools
    trash-cli
    pinentry-curses # for rbw pass input
    wl-clipboard
    brightnessctl
    pulsemixer
    libnotify
    impala
    swaybg
    swaylock-effects
    file
    exiftool
    jq
    fzf
    poppler-utils
    xdg-utils
    unzip
    zip
    localsend
    bluetuith
    prismlauncher
  ];
}
