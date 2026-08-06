{ ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      ".devd"
      ".envrc.lokal"
      ".direnv"
      ".zed/"
    ];
    settings = {
      user = {
        name = "Enes Cevik";
        email = "enes@nsvke.com";
      };
      init.defaultBranch = "main";
      core.autocrlf = "input";
      pull.rebase = true;
      url = {
        "https://github.com/" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };
}
