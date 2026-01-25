{ config, lib, ... }:
{
  options.security.enable = lib.mkEnableOption "Enable security configuration";

  config = lib.mkIf config.security.enable {
    security = {
      doas = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
            keepEnv = true;
          }
        ];
      };
      sudo.enable = false;
      polkit.enable = true;
    };
  };
}
