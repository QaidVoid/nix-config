{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardwareServices = {
    enable = lib.mkEnableOption "Enable hardware services";
    openrgb = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable OpenRGB";
    };
    libinput = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable libinput";
    };
    bluetooth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable bluetooth";
    };
    earlyoom = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable earlyoom";
    };
  };

  config = lib.mkIf config.hardwareServices.enable {
    services.hardware.openrgb = lib.mkIf config.hardwareServices.openrgb {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };

    services.libinput.enable = config.hardwareServices.libinput;

    hardware.bluetooth = lib.mkIf config.hardwareServices.bluetooth {
      enable = true;
      settings = {
        General = {
          Experimental = "true";
        };
      };
    };

    services.earlyoom = lib.mkIf config.hardwareServices.earlyoom {
      enable = true;
      enableNotifications = true;
      extraArgs = [
        "-g"
        "--prefer"
        "(^|/)(java|chromium|dms|electron|next-server)$"
        "--avoid"
        "(^|/)(niri|tmux|init|X|nixd)$"
      ];
      freeMemThreshold = 5;
    };
  };
}
