{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  bluetooth.enable = true;
  wifi.enable = true;
  dbus.enable = true;
  docker.enable = true;
  pipewire.enable = true;
  swaylock.enable = true;
  vaultwarden.enable = true;

  gpg.enable = true;
  ssh.enable = true;

  services.libinput.enable = true;
  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all       all     trust
    '';
  };
}
