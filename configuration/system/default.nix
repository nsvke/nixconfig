{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system.stateVersion = "26.05";

  imports = [
    ./boot.nix
    ./locale.nix
    ./packages.nix
    ./services.nix
    ./user.nix
    ./env.nix
  ];
}
