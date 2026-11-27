{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.shu.home.tmux;
in
{
  options.shu.home.tmux.enable = lib.mkEnableOption "Enable shu home tmux";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.tmux = {
        enable = true;
        terminal = "tmux-256color";
        keyMode = "vi";
        mouse = true;
        focusEvents = true;
        historyLimit = 50000;
        baseIndex = 1;
        escapeTime = 10;
        customPaneNavigationAndResize = true;
        resizeAmount = 2;
        plugins = with pkgs; [
          tmuxPlugins.logging
          tmuxPlugins.tmux-sessionx
          tmuxPlugins.tmux-fzf
          tmuxPlugins.better-mouse-mode
          tmuxPlugins.resurrect
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60' # minutes
            '';
          }
        ];
        extraConfig = ''
          # -- general --------------------------------------------------------
          set -g renumber-windows on
          set -g set-titles on
          setw -g automatic-rename on
          set -g automatic-rename-format '#{b:pane_current_path}'
          set -g monitor-activity on
          set -g visual-activity off
          set -g display-time 1000
          set -sg repeat-time 600

          bind r source-file ~/.config/tmux/tmux.conf \; display 'tmux.conf reloaded'

          # C-l clears the screen *and* the scrollback
          bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history

          # -- sessions -------------------------------------------------------
          bind C-c new-session
          bind C-f command-prompt -p find-session 'switch-client -t %%'
          bind BTab switch-client -l

          # -- windows & panes ------------------------------------------------
          bind - split-window -v -c "#{pane_current_path}"
          bind / split-window -h -c "#{pane_current_path}"
          bind > swap-pane -D
          bind < swap-pane -U
          bind + resize-pane -Z

          bind -r C-h previous-window
          bind -r C-l next-window
          bind Tab last-window

          # -- copy mode (vi) -------------------------------------------------
          bind Enter copy-mode
          bind -T copy-mode-vi v send -X begin-selection
          bind -T copy-mode-vi C-v send -X rectangle-toggle
          bind -T copy-mode-vi y send -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
          bind -T copy-mode-vi Escape send -X cancel
          bind -T copy-mode-vi H send -X start-of-line
          bind -T copy-mode-vi L send -X end-of-line

          # -- buffers --------------------------------------------------------
          bind b choose-buffer
          bind p paste-buffer
        '';
      };
    };
  };
}
