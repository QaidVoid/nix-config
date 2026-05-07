{
  config,
  lib,
  pkgs,
  defaults,
  ...
}:
let
  flavor = defaults.catppuccinFlavor;
  accent = defaults.catppuccinAccent;
  cursorPkg =
    let
      cap = s: (lib.toUpper (lib.substring 0 1 s)) + (lib.substring 1 (lib.stringLength s) s);
    in
    pkgs.catppuccin-cursors."${flavor}${cap accent}";
in
{
  options.userTheme.enable = lib.mkEnableOption "Enable user theme";

  config = lib.mkIf config.userTheme.enable {
    dconf.enable = true;
    gtk.enable = true;

    home.packages = with pkgs; [
      dconf

      (catppuccin-gtk.override {
        accents = [ accent ];
        variant = flavor;
      })
      (catppuccin-gtk.override {
        accents = [ accent ];
        variant = "latte";
      })

      (catppuccin-kvantum.override {
        inherit accent;
        variant = flavor;
      })
      (catppuccin-kvantum.override {
        inherit accent;
        variant = "latte";
      })

      cursorPkg
    ];

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };
  };
}
