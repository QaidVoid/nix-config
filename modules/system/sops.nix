{ config, lib, ... }:
{
  options.sops.enable = lib.mkEnableOption "Enable sops";

  config = lib.mkIf config.sops.enable {
    sops = {
      age.keyFile = "/home/qaidvoid/.config/sops/age/keys.txt";
      secrets = {
        cloudflare_token = { };
      };
    };
  };
}
