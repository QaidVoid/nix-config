{ lib, config, pkgs, ... }:
{
  options = {
    tmux.enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      # newSession = true;
      shortcut = "a";
      terminal = "xterm-256color";
      escapeTime = 0;
      baseIndex = 1;
      keyMode = "vi";
      historyLimit = 20000;
      customPaneNavigationAndResize = true;
      plugins = [
        pkgs.tmuxPlugins.continuum
        pkgs.tmuxPlugins.extrakto
      ];
      extraConfig = ''
        set -g status-position top

        bind c new-window -c "#{pane_current_path}"

        bind v split-window -h -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"

        set -g @catppuccin_flavour ${if config.theme.dark then "mocha" else "latte"}
        set -g @catppuccin_status_modules_right "session battery date_time"

        run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
        run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
      '';
    };
  };
}
