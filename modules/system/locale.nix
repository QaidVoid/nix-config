{ config, lib, ... }:
{
  options.locale.enable = lib.mkEnableOption "Enable locale configuration";

  config = lib.mkIf config.locale.enable {
    time.timeZone = "Asia/Kathmandu";

    console = {
      earlySetup = true;
    };
  };
}
