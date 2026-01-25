{ ... }:
{
  imports = [
    ./dms.nix
    ./mpv.nix
    ./packages.nix
    ./theme.nix
    ./xdg.nix
    ./zen.nix
  ];

  programs.home-manager.enable = true;
}
