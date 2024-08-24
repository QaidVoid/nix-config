{ lib, config, ... }:
{
  options = {
    vaultwarden.enable = lib.mkEnableOption "Enable vaultwarden";
  };

  config = lib.mkIf config.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        SIGNUPS_ALLOWED = false;
        ROCKET_PORT = 8192;
      };
    };
  };
}
