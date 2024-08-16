{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    # alsa.enable = true;
    pulse.enable = true;
    # jack.enable = true;
  };
  environment.systemPackages = with pkgs; [
    pulsemixer
  ];
}
