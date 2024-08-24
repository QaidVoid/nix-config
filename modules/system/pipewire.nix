{ pkgs, lib, config, ... }:
{
  options = {
    pipewire.enable = lib.mkEnableOption "Enable pipewire";
  };

  config = lib.mkIf config.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    environment.systemPackages = with pkgs; [
      pulsemixer
    ];
  };
}
