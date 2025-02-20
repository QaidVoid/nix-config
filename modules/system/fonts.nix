{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
