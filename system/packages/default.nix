{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    git
    mold
    tmux
    papirus-icon-theme
    p7zip
  ];
}
