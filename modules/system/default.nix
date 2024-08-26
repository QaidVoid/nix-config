{ lib, pkgs, opts, ... }:
{
  imports = [
    ./dbus.nix
    ./fonts.nix
    ./packages.nix
    ./pipewire.nix
    ./ssh.nix
    ./swaylock.nix
    ./vaultwarden.nix
    ./virtualisation.nix
    ./wireless.nix
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  zramSwap.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = opts.hostname;

  time.timeZone = opts.timezone;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    keyMap = opts.keymap;
  };

  users.users.${opts.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "video" ];
  };

  programs.nano.enable = false;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    groups = [ "wheel" ];
    persist = true;
    keepEnv = true;
  }];

  environment.systemPackages = [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];

  hardware.graphics.enable = true;

  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  nix.optimise.automatic = true;

  system.stateVersion = "24.05";
}
