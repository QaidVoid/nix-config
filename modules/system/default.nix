{ lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./pipewire.nix
    ./postgresql.nix
    ./sops.nix
    ./steam.nix
    ./vaultwarden.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "steam"
    "steam-unwrapped"
    "p7zip"
  ];

  boot.tmp.cleanOnBoot = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Kathmandu";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  services.libinput.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  security = {
    doas = {
      enable = true;
      extraRules = [{
        groups = [ "wheel" ];
        persist = true;
        keepEnv = true;
      }];
    };
    sudo.enable = false;
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  hardware.graphics.enable = true;
  environment.shells = with pkgs; [ fish ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.nano.enable = false;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = "true";
      };
    };
  };

  networking.dhcpcd.enable = true;

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    allowAuxiliaryImperativeNetworks = true;
  };

  networking.nameservers = [ "1.1.1.1" ];

  programs.gnupg.agent = {
    enable = true;
  };
  programs.ssh.startAgent = true;
  services.openssh.enable = true;
}
