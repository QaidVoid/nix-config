{
  config,
  lib,
  pkgs,
  ...
}:
let
  noDesktopEntries =
    names:
    lib.genAttrs names (name: {
      inherit name;
      noDisplay = true;
    });
in
{
  options.userXdg.enable = lib.mkEnableOption "Enable XDG portal";

  config = lib.mkIf config.userXdg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-wlr
      ];
      config = {
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          default = [ "gtk" "gnome" ];
        };
        mango = {
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
          default = [ "gtk" ];
        };
      };
    };

    xdg.desktopEntries = noDesktopEntries [
      "btop"
      "fish"
      "Helix"
      "mpv"
      "nixos-manual"
      "nvim"
    ];
  };
}
