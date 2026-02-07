{
  config,
  lib,
  ...
}:
{
  options.xorg = {
    enable = lib.mkEnableOption "Enable Xorg";

    displayManager = {
      type = lib.mkOption {
        type = lib.types.enum [
          "none"
          "lightdm"
          "gdm"
          "sddm"
          "startx"
        ];
        default = "none";
        description = "Display manager to use";
      };
    };

    windowManager = {
      type = lib.mkOption {
        type = lib.types.enum [
          "none"
          "i3"
          "awesome"
          "dwm"
        ];
        default = "none";
        description = "Window manager to use";
      };
    };

    desktopManager = {
      type = lib.mkOption {
        type = lib.types.enum [
          "none"
          "xfce"
          "plasma"
          "gnome"
        ];
        default = "none";
        description = "Desktop manager to use";
      };
    };

    autorun = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start Xorg automatically on boot";
    };
  };

  config = lib.mkIf config.xorg.enable {
    services.xserver = {
      enable = true;
      autorun = config.xorg.autorun;

      displayManager = {
        lightdm.enable = lib.mkIf (config.xorg.displayManager.type == "lightdm") true;
        gdm.enable = lib.mkIf (config.xorg.displayManager.type == "gdm") true;
        sddm.enable = lib.mkIf (config.xorg.displayManager.type == "sddm") true;
        startx = lib.mkIf (config.xorg.displayManager.type == "startx") {
          enable = true;
          generateScript = true;
        };
      };

      windowManager.i3 = lib.mkIf (config.xorg.windowManager.type == "i3") {
        enable = true;
      };

      desktopManager.xfce = lib.mkIf (config.xorg.desktopManager.type == "xfce") {
        enable = true;
      };
    };
  };
}
