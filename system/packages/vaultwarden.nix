{ ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8192;
    };
  };
}
