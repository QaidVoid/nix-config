{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    ffmpeg
    git
    mold
    tmux
    papirus-icon-theme
    p7zip
    qemu
    wireguard-tools
  ];
}
