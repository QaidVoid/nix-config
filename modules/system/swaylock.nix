{ lib, config, ... } :
{
  options = {
    swaylock.enable = lib.mkEnableOption "Enable swaylock";
  };

  config = lib.mkIf config.swaylock.enable {
    security.polkit.enable = true;
    security.pam.services.swaylock = {};
  };
}
