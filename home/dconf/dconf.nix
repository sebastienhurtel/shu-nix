{ config, lib, pkgs, ... }: {
  dconf = {
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        move-to-workspace-left="['<Shift><Super>k']";
        move-to-workspace-right="['<Shift><Super>j']";
        switch-to-workspace-1="['<Super>1']";
        switch-to-workspace-2="['<Super>2']";
        switch-to-workspace-3="['<Super>3']";
        switch-to-workspace-4="['<Super>4']";
        switch-to-workspace-left="['<Super>Page_Up']";
        switch-to-workspace-right="['<Super>Page_Down']";
        toggle-maximized="['<Super>Up']";
      };
    };
  };
}
