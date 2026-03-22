{ config, lib, ... }:
{
  options.desktop.enable = lib.mkEnableOption "Enable desktop profile";

  config = lib.mkIf config.desktop.enable {
    userTheme.enable = true;
    userXdg.enable = true;
  };
}
