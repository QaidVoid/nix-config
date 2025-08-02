{ pkgs, ... }:
{
  dconf.enable = true;
  gtk.enable = true;

  home.packages = with pkgs; [
    dconf

    (catppuccin-gtk.override {
      accents = [ "flamingo" ];
      variant = "mocha";
    })
    (catppuccin-gtk.override {
      accents = [ "flamingo" ];
      variant = "latte";
    })

    (catppuccin-kvantum.override {
      accent = "flamingo";
      variant = "mocha";
    })
    (catppuccin-kvantum.override {
      accent = "flamingo";
      variant = "latte";
    })

    catppuccin-cursors.mochaFlamingo
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
}
