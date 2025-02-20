{ pkgs, ... }:
{
  home.packages = with pkgs; [
    catppuccin-gtk
    brightnessctl
    btop
    delta
    eww
    eza
    fastfetch
    fd
    fuzzel
    fzf
    glib
    imv
    jq
    libnotify
    qbittorrent
    ripgrep
    swaybg
    tlrc
    wl-clipboard
    xdg-utils
    yt-dlp
  ];

  xdg.desktopEntries.btop = {
    name = "btop";
    noDisplay = true;
  };
}
