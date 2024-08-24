{ pkgs, lib, config, ... }:
{
  options = {
    niri.enable = lib.mkEnableOption "Enable niri window manager";
  };

  config = lib.mkIf config.niri.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = [ "gnome" ];
    };

    home.packages = with pkgs; [
      niri
    ];
  };
}
