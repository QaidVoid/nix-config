{ ... }:
{
  networking.wireless = {
    enable = true;
    environmentFile = "/root/secrets/wireless.env";
    networks."@SSID@".psk = "@PSK@";
  };
}
