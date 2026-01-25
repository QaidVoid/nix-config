{ config, lib, ... }:
{
  options.server.enable = lib.mkEnableOption "Enable server profile";

  config = lib.mkIf config.server.enable {
    postgresql.enable = true;
    vaultwarden.enable = true;
  };
}
