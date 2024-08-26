{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  # zen kernel is broken
  boot.kernelPackages = pkgs.linuxPackages_latest;

  dbus.enable = true;
  pipewire.enable = true;
  swaylock.enable = true;

  gpg.enable = true;
  ssh.enable = true;

  services.libinput.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
