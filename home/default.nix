{ ... }:
{
  programs.home-manager.enable = true;

  home.username = "enes";
  home.homeDirectory = "/home/enes";

  imports = [
    ./modules
  ];

  home.stateVersion = "26.05";
}
