{ ... }:
{
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
      "--disable-ai"
    ];
    settings = {
      filter_mode_shell_up_key_binding = "directory";
      inline_height_shell_up_key_binding = "1";
      columns = [
        "duration"
        "command"
      ];
    };
  };
}
