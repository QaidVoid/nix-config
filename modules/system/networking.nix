{ config, lib, defaults, ... }:
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
    networking.nameservers = defaults.dnsServers;
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
      };
    };
  };
}
