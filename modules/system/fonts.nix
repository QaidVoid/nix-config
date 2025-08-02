{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
