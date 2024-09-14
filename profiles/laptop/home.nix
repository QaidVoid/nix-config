{ pkgs, config, ... }:
let
  configdir = "${config.home.homeDirectory}/nix-config";
  sym = config.lib.file.mkOutOfStoreSymlink;
in {
  imports = [
    ../../modules/user
  ];

  development.enable = true;
  niri.enable = true;
  direnv.enable = true;
  swaylock.enable = true;
  swayidle.enable = true;

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
    ".config/foot".source = sym "${configdir}/dotfiles/foot";
    ".config/niri".source = sym "${configdir}/dotfiles/niri";
  };
}
