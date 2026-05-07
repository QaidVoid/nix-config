{ config, lib, defaults, ... }:
{
  options.sops.enable = lib.mkEnableOption "Enable sops";

  config = lib.mkIf config.sops.enable {
    sops = {
      age.keyFile = "${defaults.homeDirectory}/.config/sops/age/keys.txt";
      secrets = {
        cloudflare_token = { };
      };
    };
  };
}
