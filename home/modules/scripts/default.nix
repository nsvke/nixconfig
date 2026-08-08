{ pkgs, ... }:
let
  audio-control = pkgs.writeShellApplication {
    name = "audio-control";
    runtimeInputs = with pkgs; [
      wireplumber
      libnotify
      coreutils
      gawk
      gnugrep
    ];
    text = builtins.readFile ./audio-control.sh;
  };
  chck = pkgs.writeShellApplication {
    name = "chck";
    runtimeInputs = with pkgs; [
      ripgrep
      cbonsai
    ];
    text = builtins.readFile ./chck.sh;
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
in
pkgs.symlinkJoin {
  name = "home-scripts";
  paths = [
    audio-control
    chck
    finit
  ];
}
