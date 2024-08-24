{ pkgs, lib, config, ... }:
{
  options = {
    dbus.enable = lib.mkEnableOption "Enable D-Bus";
  };

  config = lib.mkIf config.dbus.enable {
    services.dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    programs.dconf.enable = true;
  };
}
