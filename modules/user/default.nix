{ lib, ... }:
{
  imports = [
    ./mpv.nix
    ./packages.nix
    ./theme.nix
    ./xdg.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "youtube-upnext"
    "burpsuite"
  ];

  programs.home-manager.enable = true;
}
