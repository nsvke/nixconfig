{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      "delta1" = "git diff --cached | delta";
      "ls" = "eza -alF --icons";
      "etree" = "eza -aF --git-ignore --tree";
      "etreel" = "etree --level";
      "zp" = "WGPU_POWER_PREF=low zeditor .";
      "zed" = "WGPU_POWER_PREF=low zeditor";
      "e" = "exit";
      "r" = "reset";
      "sns" = "sudo nixos-rebuild switch --flake /home/enes/.config/nixos/.#enes";
      "hms" = "home-manager switch --flake /home/enes/.config/nixos/.#\"enes@rog\"";
      "zc" = "zeditor ~/.config/nixos";
      "screenshot" = "echo 'use ctrl+shift+f1'";
      "ns" = "nix shell nixpkgs#";
      "nr" = "nix run nixpkgs#";
      
      "add_fish_alias" = "hx ~/.config/fish/config.fish";

      "nixenv" = "echo 'use nix' > .envrc && direnv allow";
      "flakenv" = "echo 'use flake' > .envrc && direnv allow";

      "phonecam" =
        "scrcpy --video-source=camera --camera-facing=back --camera-size=1920x1080 --v4l2-sink=/dev/video9 --no-audio";
      "phone" = "SDL_RENDER_DRIVER=vulkan scrcpy --turn-screen-off --stay-awake --no-audio --max-fps=60";
    };
    functions.tn.body = ''
      set -l tmp_file /tmp/(date +%s)
      hx $tmp_file
    '';
  };
}
