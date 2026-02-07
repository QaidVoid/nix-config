{
  config,
  lib,
  ...
}:
{
  options.sunshine = {
    enable = lib.mkEnableOption "Enable Sunshine game streaming service";
  };

  config = lib.mkIf config.sunshine.enable {
    services.sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
      autoStart = true;
    };
  };
}
