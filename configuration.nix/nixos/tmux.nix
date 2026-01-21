{ pkgs, ... }:

let
  menuPosition = "M"; # "C" for Center, "M" for Mouse location
  amber  = "yellow";
  active = "brightyellow";
  lite   = "green";
  alert  = "red";
in
{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    
    plugins = with pkgs.tmuxPlugins; [ 
      sensible     
      yank         
      resurrect    
      continuum    
    ];

    extraConfig = ''
      # --- THEME ---
      set -g status-style bg=black,fg=${amber}
      set -g window-style "fg=${amber},bg=black"
      set -g window-active-style "fg=${active},bg=black"
      set -g window-status-current-style "fg=black,bg=${amber},bold"
      set -g window-status-style "fg=${lite},bg=black"
      set -g window-status-format " #[fg=${alert}]•#[fg=${lite}]#I:#W "
      set -g window-status-current-format " ★ #I:#W "
      set -g window-status-separator ""

      # --- LOGIC ---
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on
      setw -g mode-keys vi
      set -g mouse on

      # --- MENUS ---
      # Unbind standard right-click to allow Windows standard paste
      unbind -n MouseDown3Pane
      unbind -n MouseDown3Status

      # TAB MENU (Right click on the status bar)
      bind -n MouseDown3Status display-menu -x W -y S \
        "★ TAB ACTIONS ★"          "" "" \
        "• New Tab"                n "new-window" \
        "• Rename Tab"             r "command-prompt -I '#W' 'rename-window %%'" \
        "• Close Tab"              X "confirm-before -p \"Kill window #W? (y/n)\" kill-window"

      # VIEWPORT MENU (Alt + Right Click OR F8)
      # This handles the paste fix
      bind -n M-MouseDown3Pane display-menu -x ${menuPosition} -y ${menuPosition} \
        "★ SYSTEM COMMANDS ★"   "" "" \
        "• Paste from Windows"   p "run-shell 'powershell.exe -Command Get-Clipboard | tmux load-buffer - && tmux paste-buffer'" \
        "• Select All Text"      a "copy-mode; send-keys -X history-top; send-keys -X begin-selection; send-keys -X history-bottom" \
        "• Synchronize Panes"    S "setw synchronize-panes" \
        " "                      "" "" \
        "★ DOCUMENTATION ★"      "" "" \
        "📜 Toggle Lab Help"     h "display-popup -E -w 80% -h 80% 'less -R -~ ~/help.md'"

      bind -n F8 display-menu -x C -y C \
        "★ SYSTEM COMMANDS ★"   "" "" \
        "• Paste from Windows"   p "run-shell 'powershell.exe -Command Get-Clipboard | tmux load-buffer - && tmux paste-buffer'" \
        "• Select All Text"      a "copy-mode; send-keys -X history-top; send-keys -X begin-selection; send-keys -X history-bottom" \
        "• Synchronize Panes"    S "setw synchronize-panes" \
        " "                      "" "" \
        "★ DOCUMENTATION ★"      "" "" \
        "📜 Toggle Lab Help"     h "display-popup -E -w 80% -h 80% 'less -R -~ ~/help.md'"

      # --- NAVIGATION ---
      set -g prefix F1
      unbind C-b
      bind F1 send-prefix
      bind -n F2 new-window -c "#{pane_current_path}"
      bind -n F3 previous-window
      bind -n F4 next-window
      bind -n F5 split-window -h -c "#{pane_current_path}"
      bind -n F6 split-window -v -c "#{pane_current_path}"
      bind -n F7 resize-pane -Z
      bind -n F9 copy-mode
      bind -n F10 confirm-before -p "Kill pane? (y/n)" kill-pane

      # CLIPBOARD SETTINGS
      set -g @yank_selection_mouse 'clipboard'
    '';
  };
}
