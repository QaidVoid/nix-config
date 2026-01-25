{ ... }:
{
  imports = [
    ./cli.nix
    ./dms.nix
    ./mpv.nix
    ./packages.nix
    ./theme.nix
    ./xdg.nix
    ./zen.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
