{ pkgs, ... }:
{
  imports = [
    ../../modules/user
  ];

  development.enable = true;
  niri.enable = true;
  direnv.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];
    };
  };

  home.packages = with pkgs; [
    affine
    chromium
    qutebrowser
    telegram-desktop
    typst
    typstfmt
    typst-lsp
    vesktop
    xwayland-satellite
    zathura
  ];

  home.file = {
    ".config/foot".source = ../../dotfiles/foot;
    ".config/niri".source = ../../dotfiles/niri;
  };
}
