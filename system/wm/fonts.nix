{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerdfonts
    jetbrains-mono
  ];
}
