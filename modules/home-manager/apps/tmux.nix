{ config, lib, ... }:

with lib;

{
  imports = [ ../terminal.nix ];

  config = {
    programs.tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        # Vi copypaste mode
        bind-key Escape copy-mode
        bind-key p paste-buffer
        bind-key -Tcopy-mode-vi 'v' send -X begin-selection
        bind-key -Tcopy-mode-vi 'y' send -X copy-selection
        bind-key e save-buffer ~/.tmux-buffer \; run-shell "xsel -i -b <~/.tmux-buffer && rm ~/.tmux-buffer"

        # split windows
        unbind %
        bind-key | split-window -h -c "#{pane_current_path}"
        unbind '"'
        bind-key - split-window -v -c "#{pane_current_path}"

        # swap windows
        bind-key -n S-Left swap-window -t -1
        bind-key -n S-Right swap-window -t +1

        # auto window rename
        set -g automatic-rename off

        # enable mouse
        set-option -g mouse on

        # Set title
        set -g set-titles on

        # powerline
        set -g status-left-length 20
        set -g status-justify "left"
        set -g status-left-length "100"
        set -g status "on"
        set -g pane-active-border-style fg=colour23
        set -g message-style bg=colour13
        set -g status-right-length "100"
        set -g status-right-style "none"
        set -g message-command-style fg=colour255,bg=colour236
        set -g status-style fg=colour231,bg=colour234,bg=colour234,"none"
        set -g pane-border-style fg=colour236
        set -g status-left-style "none"
        setw -g window-status-activity-style bg=colour234,"none",fg=colour190
        setw -g window-status-separator ""
        setw -g window-status-style fg=colour85,"none",bg=colour234
        set -g status-left "#[fg=colour255,bg=colour23]#S #[fg=colour23,bg=colour234,nobold,nounderscore,noitalics]"
        set -g status-right "#[fg=colour234,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236,nobold,nounderscore,noitalics]#{pane_current_path}"
        setw -g window-status-format "#[fg=colour85,bg=colour234] #I:#[fg=colour85,bg=colour239] #W "
        setw -g window-status-current-format "#[fg=colour234,bg=colour23,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour23] #I:#[fg=colour247,bg=colour23] #W #[fg=colour23,bg=colour234,nobold,nounderscore,noitalics]"

        bind-key -n C-y send-prefix

        bind-key c command-prompt -p "window name:" "new-window; rename-window '%%'"
      '';
    };

    programs.terminal.run = mkDefault ''tmux new-session -A -s ''${WORKSPACE:-main}'';
  };
}
