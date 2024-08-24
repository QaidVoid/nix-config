{ pkgs, ... }:
{
  imports = [
    ../../modules/user
  ];

  development.enable = true;
  niri.enable = true;

  home.packages = with pkgs; [
    affine
    chromium
    telegram-desktop
    tree
    typst
    typstfmt
    typst-lsp
    vesktop
  ];

  home.file = {
    ".config/foot".source = ../../dotfiles/foot;
    ".config/niri".source = ../../dotfiles/niri;
  };
}
