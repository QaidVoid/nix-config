{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    brightnessctl
    btop
    cloudflare-warp
    delta
    eww
    eza
    fastfetch
    fd
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
