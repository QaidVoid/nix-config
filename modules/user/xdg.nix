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
      ];
      config = {
        common.default = [ "gtk" "gnome" ];
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          default = [ "gtk" "gnome" ];
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
