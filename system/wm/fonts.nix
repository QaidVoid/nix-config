{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    jetbrains-mono
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly"]; })
  ];
}
