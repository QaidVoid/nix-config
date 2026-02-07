{ config, lib, ... }:
{
  options.networking.enable = lib.mkEnableOption "Enable networking configuration";

  config = lib.mkIf config.networking.enable {
    networking.dhcpcd.enable = true;
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
    networking.firewall.enable = false;
    networking.nameservers = [ "1.1.1.1" ];
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
      };
    };
  };
}
