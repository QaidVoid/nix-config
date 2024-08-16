{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/shared
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/wifi.nix
    ../../system/packages
    ../../system/packages/docker.nix
    ../../system/security/doas.nix
    ../../system/security/gpg.nix
    ../../system/security/ssh.nix
    ../../system/wm/dbus.nix
    ../../system/wm/fonts.nix
    ../../system/wm/pipewire.nix
    ../../system/wm/security.nix
    ../../system/wm/xdp.nix
  ];

  services.libinput.enable = true;
}
