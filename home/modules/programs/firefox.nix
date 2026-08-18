{ ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      isDefault = true;
      path = "2uf77zaa.default";

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        #TabsToolbar {
          visibility: collapse !important;
        }

        #sidebar-main, 
        box#sidebar-main,
        #sidebar-main-container,
        #vertical-tabs-button, 
        #sidebar-button,
        #sidebar-header,
        splitter#sidebar-splitter,
        .sidebar-splitter,
        #sidebar-splitter {
          display: none !important;
          visibility: hidden !important;
          width: 0px !important;
          pointer-events: none !important;
        }

        #nav-bar {
          padding-top: 2px !important;
          padding-bottom: 2px !important;
          background: transparent !important; 
        }

        #urlbar-container {
          --urlbar-container-height: 28px !important;
          padding-top: 0px !important;
          padding-bottom: 0px !important;
        }

        #urlbar[focused="true"] #urlbar-background {
          border-color: rgba(0, 0, 0, 0.2) !important;
          box-shadow: none !important;
        }
    '';
  };
};
}
