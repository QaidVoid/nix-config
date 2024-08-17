{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    git
    mold
    tmux
    p7zip
  ];
}
