{ inputs, ... }:
{
  programs.quickshell.enable = true;
  xdg.configFile."quickshell".source = inputs.modal-shell;
}
