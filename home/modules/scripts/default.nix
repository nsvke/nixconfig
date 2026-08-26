{ pkgs, flakeDir, ... }:
let
  haudio = pkgs.writeShellApplication {
    name = "haudio";
    runtimeInputs = with pkgs; [
      wireplumber
      libnotify
      coreutils
      gawk
      gnugrep
    ];
    text = builtins.readFile ./haudio.sh;
  };
  hck = pkgs.writeShellApplication {
    name = "hck";
    runtimeInputs = with pkgs; [
      ripgrep
      cbonsai
    ];
    text = builtins.readFile ./hck.sh;
  };
  finit = pkgs.writeShellApplication {
    name = "finit";
    runtimeInputs = with pkgs; [
      coreutils
      helix
      direnv
    ];
    text = builtins.readFile ./finit.sh;
  };
  fup = pkgs.writeShellApplication {
    name = "fup";
    runtimeInputs = with pkgs; [ git nix jq libnotify coreutils ];
    text = builtins.replaceStrings [ "@flakeDir@" ] [ flakeDir ] (builtins.readFile ./fup.sh);
  };
  fns = pkgs.writeShellApplication {
    name = "fns";
    runtimeInputs = with pkgs; [ nixos-rebuild ];
    text = ''
        sudo nixos-rebuild switch --flake "${flakeDir}#$(hostname)" "$@"
      '';
  };
  fhs = pkgs.writeShellApplication {
    name = "fhs";
    runtimeInputs = with pkgs; [ home-manager ];
    text = ''
        home-manager switch --flake "${flakeDir}#\"$(whoami)@$(hostname)\"" "$@"
      '';
  };
  hnet = pkgs.writeShellApplication {
    name = "hnet";
    runtimeInputs = with pkgs; [
      util-linux
      iwd
      bluez
      coreutils
      gnugrep
      gawk
      iproute2
      jq
    ];
    text = builtins.readFile ./hnet.sh;
  };
  hfp = pkgs.writeShellApplication {
    name = "hfp";
    runtimeInputs = with pkgs; [ niri ];
    text = ''niri msg action spawn -- footclient -D "$PWD"'';
  };
in
{
  home.packages = [
    haudio
    hck
    finit
    fup
    fns
    fhs
    hnet
    hfp
  ];
}
