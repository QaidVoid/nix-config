{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clang
    git
    mold
    neovim
    tmux
    p7zip
  ];
}
