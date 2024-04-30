{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnome.adwaita-icon-theme
    papirus-icon-theme
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.gsconnect
    gnomeExtensions.pop-shell
    gnomeExtensions.appindicator
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
        cycle-group = [ "disabled" ];
        cycle-group-backward = [ "disabled" ];
        maximize = [ "disabled" ];
        minimize = [ "disabled" ];
        move-to-workspace-1 = [ "disabled" ];
        move-to-workspace-last = [ "disabled" ];
        move-to-workspace-left = [ "<Shift><Super>k" ];
        move-to-workspace-right = [ "<Shift><Super>j" ];
        switch-group = [ "disabled" ];
        switch-group-backward = [ "disabled" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-last = [ "disabled" ];
        switch-to-workspace-left = [ "<Super>Page_Up" ];
        switch-to-workspace-right = [ "<Super>Page_Down" ];
        toggle-maximized = [ "<Super>Up" ];
      };
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
