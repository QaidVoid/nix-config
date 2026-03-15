{ lib, config, pkgs, ... }:
{
  options = {
    pipewire.enable = lib.mkEnableOption "Enable pipewire";
  };

  config = lib.mkIf config.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire-pulse = {
        "10-block-chromium" = {
          "pulse.rules" = [
            {
              matches = [
                {
                  "application.name" = "*";
                }
              ];
              actions = {
                options = [ "block-source-volume" ];
              };
            }
          ];
        };
      };
    };
  };
}
