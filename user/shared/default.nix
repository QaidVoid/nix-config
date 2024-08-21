{ pkgs, ... }:
let
  options = import (./. + "/../../options.nix");
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = options.username;
  home.homeDirectory = "/home/" + options.username;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    bat
    btop
    cloudflare-warp
    delta
    eww
    eza
    fastfetch
    fd
    firefox
    foot
    fuzzel
    fzf
    imv
    jq
    libnotify
    mpv
    qbittorrent
    ripgrep
    swaybg
    swayidle
    swaylock
    tlrc
    wl-clipboard
    xdg-utils
    yt-dlp
  ];
}
