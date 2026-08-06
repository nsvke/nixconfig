{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    initLua = ''
      require("git"):setup()
      require("projects"):setup({})
      require("bookmarks"):setup({})
      require("smart-enter"):setup({})
      require("restore"):setup({})
    '';
    flavors = {
      dracula = ./flavors/dracula.yazi;
    };
    theme = {
      flavor = {
        dark = "dracula";
      };
      mgr = {
        border_style = {
          fg = "#222222";
        };
      };
    };
    settings = {
      mgr = {
        ratio = [
          24
          31
          45
        ];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
        linemode = "none";
      };
      preview = {
        max_width = 1920;
        max_height = 1080;
        image_filter = "lanczos3";
        image_quality = 80;
        tab_size = 2;
      };
      plugin = {
        prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        prepend_previewers = [
          {
            url = "*.md";
            run = "piper -- mdcat \"$1\"";
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          run = "shell 'footclient' --orphan";
          on = [ "T" ];
          desc = "Open terminal on pwd";
        }
        {
          run = "plugin chmod";
          on = [
            "c"
            "m"
          ];
          desc = "Chmod on selected files";
        }
        {
          run = "plugin projects save";
          on = [
            "P"
            "s"
          ];
          desc = "Save current project";
        }
        {
          run = "plugin projects load";
          on = [
            "P"
            "l"
          ];
          desc = "Load project";
        }
        {
          run = "plugin projects delete";
          on = [
            "P"
            "d"
          ];
          desc = "Delete project";
        }
        {
          run = "plugin projects load_last";
          on = [
            "P"
            "P"
          ];
          desc = "Load last project";
        }
        {
          run = "plugin bookmarks save";
          on = [ "M" ];
          desc = "Save current position as a bookmark";
        }
        {
          run = "plugin bookmarks jump";
          on = [ "'" ];
          desc = "Jump to a bookmark";
        }
        {
          run = "plugin bookmarks delete";
          on = [
            "b"
            "d"
          ];
          desc = "Delete a bookmark";
        }
        {
          run = "plugin restore";
          on = [ "u" ];
          desc = "Restore last deleted item";
        }
        {
          run = "plugin smart-filter";
          on = [ "F" ];
          desc = "Smart filter";
        }
        {
          run = "plugin smart-enter";
          on = [ "l" ];
          desc = "Smart enter";
        }
        # {
          # run = "plugin smart-paste";
          # on = [ "p" ];
          # desc = "Smart paste";
        # }
      ];
    };
    plugins = {
      chmod = pkgs.yaziPlugins.chmod;
      git = pkgs.yaziPlugins.git;
      piper = pkgs.yaziPlugins.piper;
      projects = pkgs.yaziPlugins.projects;
      bookmarks = pkgs.yaziPlugins.bookmarks;
      smart-filter = pkgs.yaziPlugins.smart-filter;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      # smart-paste = pkgs.yaziPlugins.smart-paste;
      restore = pkgs.yaziPlugins.restore;
    };
  };
}
