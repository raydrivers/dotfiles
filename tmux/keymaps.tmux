# Prefix key
unbind C-b
set-option -g prefix C-Space
bind-key C-Space send-prefix

# Vi copies
set-window-option -g mode-keys vi
bind-key -Tcopy-mode-vi v send -X begin-selection
bind-key -Tcopy-mode-vi y send -X copy-selection-and-cancel

# Navigation
bind Space last-window

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind -r C-j resize-pane -D 15
bind -r C-k resize-pane -U 15
bind -r C-h resize-pane -L 15
bind -r C-l resize-pane -R 15

# Windows
bind -r "<" swap-window -d -t -1
bind -r ">" swap-window -d -t +1

