{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
    tlrc
    wl-clipboard
    xdg-utils
    yt-dlp
  ];
}
