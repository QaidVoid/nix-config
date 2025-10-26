{ lib, ... }:
{
  imports = [
    ./mpv.nix
    ./packages.nix
    ./swayidle.nix
    ./theme.nix
    ./xdg.nix
    ./zen.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "aseprite"
    "youtube-upnext"
    "burpsuite"
  ];

  programs.home-manager.enable = true;
}
