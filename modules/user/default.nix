{ lib, ... }:
{
  imports = [
    ./dms.nix
    ./mpv.nix
    ./packages.nix
    ./theme.nix
    ./xdg.nix
    ./zen.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "aseprite"
    "youtube-upnext"
    "burpsuite"
    "discord-ptb"
    "claude-code"
    "upwork"
    "slack"
  ];

  programs.home-manager.enable = true;
}
