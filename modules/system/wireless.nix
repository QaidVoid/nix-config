{ lib, config, ... }:
{
  options = {
    bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
    wifi.enable = lib.mkEnableOption "Enable wireless networking";
  };

  config = lib.mkMerge [
    (lib.mkIf config.bluetooth.enable {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    })

    (lib.mkIf config.wifi.enable {
      networking.wireless = {
        enable = true;
        environmentFile = "/root/secrets/wireless.env";
        networks."@SSID@".psk = "@PSK@";
      };
    })
  ];
}
