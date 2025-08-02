{ lib, config, ... }:
{
  options = {
    steam.enable = lib.mkEnableOption "Enable Steam";
  };

  config = lib.mkIf config.steam.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}
