{ lib, pkgs, ... }:
let
  noDesktopEntries = names:
    lib.genAttrs names (name: {
      inherit name;
      noDisplay = true;
    });
in
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gnome" ];
  };

  xdg.desktopEntries = noDesktopEntries [
    "btop"
    "fish"
    "Helix"
    "mpv"
    "nixos-manual"
    "nvim"
  ];
}
