{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      git = {
        pagers = {
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
