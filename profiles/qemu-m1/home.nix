{ pkgs, ... }:
{
  imports = [
    ../../modules/user
  ];

  development.enable = true;
  niri.enable = true;

  home.file = {
    ".config/foot".source = ../../dotfiles/foot;
    ".config/niri".source = ../../dotfiles/niri;
  };
}
