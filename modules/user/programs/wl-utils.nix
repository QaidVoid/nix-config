{ pkgs, lib, config, ... }:
{
  options = {
    swaylock.enable = lib.mkEnableOption "Enable swaylock";
    swayidle.enable = lib.mkEnableOption "Enable swayidle";
  };

  config = lib.mkMerge [
    (lib.mkIf config.swaylock.enable {
      programs.swaylock = {
        enable = true;
        settings = {
          hide-keyboard-layout = true;
          image = "${config.home.homeDirectory}/Pictures/Wallpapers/default-lock.png";
          ignore-empty-password = true;
          show-failed-attempts = true;
        };
      };
    })

    (lib.mkIf config.swayidle.enable {
      assertions = [{
        assertion = config.swaylock.enable;
        message = "swayidle requires swaylock to be enabled";
      }];

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
        ];
      };

      systemd.user.services.swayidle = {
        Unit.After = [ "niri.service" ];
      };
    })
  ];
}
