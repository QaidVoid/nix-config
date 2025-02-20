{ lib, config, ... }:
{
  options = {
    yazi.enable = lib.mkEnableOption "Enable yazi";
  };

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };
    xdg.desktopEntries.yazi = {
      name = "yazi";
      noDisplay = true;
    };
  };
}
