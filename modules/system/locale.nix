{ config, lib, defaults, ... }:
{
  options.locale.enable = lib.mkEnableOption "Enable locale configuration";

  config = lib.mkIf config.locale.enable {
    time.timeZone = defaults.timezone;
    i18n.defaultLocale = defaults.locale;

    console = {
      earlySetup = true;
    };
  };
}
