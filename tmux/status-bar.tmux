set -g @status_bg "#22252b"

set -g status-style "bg=#{@status_bg},fg=#{@light_gray}"
set -g status-justify right
set -g status-position bottom

# Left side: Session name with charcoal and steel blue
set -g status-left-length 48
set -g status-left '    #[fg=#{@teal}]#H#[fg=#{@dark_red},bold]:#[fg=#{@dark_red}]#S#[default]    '

# Right side: Hostname, battery, time, and date using teal, tan, lavender
set -g status-right-length 48
set -g status-right '    #[fg=#{@lavender}]%Y-%m-%d#[fg=#{@tan}]T#[fg=#{@tan},bold]%H:%M    '

# Windows
set-window-option -g window-status-current-style "fg=#{@dark_red},bg=default,bold"
set-window-option -g window-status-style "fg=#{@teal},bg=default"

set-option -g pane-border-style "fg=#{@steel_blue}"
set-option -g pane-active-border-style "fg=#{@steel_blue}"

set-option -g message-style "fg=#{@dark_red},bold,reverse"
set-option -g message-command-style "fg=#{@steel_blue},bold,reverse"