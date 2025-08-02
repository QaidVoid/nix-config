{ lib, config, pkgs, ... }:
{
  options = {
    postgresql.enable = lib.mkEnableOption "Enable PostgreSQL";
  };

  config = lib.mkIf config.postgresql.enable {
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE qaidvoid WITH LOGIN PASSWORD 'password' CREATEDB;
      '';
    };
  };
}
