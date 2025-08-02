{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gnome" ];
  };

  xdg.desktopEntries = {
    btop = {
      name = "btop";
      noDisplay = true;
    };
    fish = {
      name = "fish";
      noDisplay = true;
    };
    helix = {
      name = "helix";
      noDisplay = true;
    };
    mpv = {
      name = "mpv";
      noDisplay = true;
    };
    nixos-manual = {
      name = "nixos-manual";
      noDisplay = true;
    };
    nvim = {
      name = "nvim";
      noDisplay = true;
    };
  };
}
