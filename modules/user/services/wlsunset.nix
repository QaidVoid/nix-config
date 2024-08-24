{ lib, config, ... }:
{
  options = {
    wlsunset.enable = lib.mkEnableOption "Enable wlsunset notification service";
  };

  config = lib.mkIf config.mako.enable {
    services.wlsunset = {
      enable = true;
      latitude = 28.39;
      longitude = 84.12;
      temperature = {
        day = 4500;
        night = 4000;
      };
    };
  };
}
