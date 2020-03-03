{ config, lib, pkgs, ... }:

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
      plugins = with pkgs.tmuxPlugins; [
        logging
        fzf-tmux-url
      ];
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

        # Status update interval
        set -g status-interval 1

        # Basic status bar colors
        set -g status-style 'fg=colour21,bg=colour18'

        # Left side of status bar
        set -g status-left-style 'bg=default,fg=default'
        set -g status-left-length 150
        set -g status-left "#[fg=colour18,bg=colour2,bold] #S #[fg=colour2,bg=colour19,nobold]#[fg=colour21,bg=colour19] #(whoami) #[fg=colour19,bg=colour20]#[fg=colour15,bg=colour20] #I:#P #[fg=colour20,bg=default,nobold] #{pane_current_command} #{simple_git_status}"

        # Right side of status bar
        set -g status-right-style 'bg=default,fg=default'
        set -g status-right-length 150
        set -g status-right "#[fg=colour06]#{pane_current_path} #[fg=colour20,bg=default]#[fg=colour15,bg=colour20] %H:%M:%S #[fg=colour19,bg=colour20]#[fg=colour21,bg=colour19] %d-%b-%y #[fg=colour06,bg=colour19]#[fg=colour18,bg=colour06,bold] #H "

        # Window status
        set -g window-status-format " #I:#W#F "
        set -g window-status-current-format " #[fg=colour18,bg=colour02] #I:#W#F "

        # Current window status
        set -g window-status-current-style 'bg=default,fg=default'

        # Window with activity status
        set -g window-status-activity-style 'bg=default,fg=default'

        # Window separator
        set -g window-status-separator ""

        # Window status alignment
        set -g status-justify centre

        # Pane border
        set -g pane-border-style 'bg=default,fg=colour18'

        # Active pane border
        set -g pane-active-border-style 'bg=default,fg=colour04'

        # Pane number indicator
        set -g display-panes-colour default
        set -g display-panes-active-colour default

        # Clock mode
        set -g clock-mode-colour colour04
        set -g clock-mode-style 12

        # Message
        set -g message-style 'bg=colour16,fg=colour18'

        # Command message
        set -g message-command-style 'bg=colour16,fg=colour18'

        # Mode
        set -g mode-style 'bg=colour19,fg=colour18'

        bind-key -n C-y send-prefix

        bind-key c command-prompt -p "window name:" "new-window; rename-window '%%'"
      '';
    };

    programs.terminal.run = mkDefault ''bash -i -c "tmux new-session -A -s ''${WORKSPACE:-main}"'';
  };
}
