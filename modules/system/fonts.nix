{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.fonts.enable = lib.mkEnableOption "Enable fonts";

  config = lib.mkIf config.fonts.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };
}
