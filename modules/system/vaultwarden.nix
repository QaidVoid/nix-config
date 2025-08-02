{ lib, config, ... }:
{
  options = {
    vaultwarden.enable = lib.mkEnableOption "Enable Vaultwarden";
  };

  config = lib.mkIf config.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        SIGNUPS_ALLOWED = false;
        ROCKET_PORT = 8192;
        DATA_FOLDER = "/var/lib/vaultwarden";
        WEB_VAULT_ENABLED = true;
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts."vault.qaidvoid.dev" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8192";
        };
        forceSSL = true;
        useACMEHost = "vault.qaidvoid.dev";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "contact+acme@qaidvoid.dev";
      certs."vault.qaidvoid.dev" = {
        domain = "vault.qaidvoid.dev";
        group = "nginx";
        dnsProvider = "cloudflare";
        environmentFile = "${config.sops.secrets.cloudflare_token.path}";
      };
    };
  };
}
