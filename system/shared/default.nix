{ pkgs, ... }:
let
  options = import (./. + "/../../options.nix");
in
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  zramSwap.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = options.hostname;

  time.timeZone = options.timezone;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    keyMap = options.keymap;
  };

  users.users.${options.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "video" ];
  };

  programs.nano.enable = false;

  hardware.graphics.enable = true;

  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nix.optimise.automatic = true;

  system.stateVersion = "24.05";
}
