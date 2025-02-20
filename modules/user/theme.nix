{ pkgs, config, lib, ... }:
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = if config.theme.dark then "Catppuccin-Mocha" else "Catppuccin-Latte";
        color-scheme = if config.theme.dark then "prefer-dark" else "default";
      };
    };
  };
  
  gtk = lib.mkForce {
    enable = true;
    theme = {
      catppuccinMocha = {
        name = "Catppuccin-Mocha";
        package = pkgs.catppuccin-gtk.override {
          size = "standard";
          variant = "mocha";
        };
      };
      catppuccinLatte = {
        name = "Catppuccin-Latte";
        package = pkgs.catppuccin-gtk.override {
          size = "standard";
          variant = "latte";
        };
      };
    }.${config.theme.name};
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
      };
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = config.theme.dark;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = config.theme.dark;
    cursorTheme = {
      catppuccinMocha = {
        name = "Catppuccin-Mocha-Cursors";
        package = pkgs.catppuccin-cursors.mochaDark;
      };
      catppuccinLatte = {
        name = "Catppuccin-Latte-Cursors";
        package = pkgs.catppuccin-cursors.latteLight;
      };
    }.${config.theme.name};
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = if config.theme.dark then "Catppuccin-Mocha-Cursors" else "Catppuccin-Latte-Cursors";
    package = if config.theme.dark then pkgs.catppuccin-cursors.mochaDark else pkgs.catppuccin-cursors.latteLight;
    size = 16;
  };

  catppuccin = {
    enable = true;
    flavor = if config.theme.dark then "mocha" else "latte";
    tmux = {
      enable = false;
    };
  };


  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    General.theme = if config.theme.dark then "Catppuccin-Mocha" else "Catppuccin-Latte";
  };
}
