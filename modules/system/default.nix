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

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  nix.settings.trusted-users = [ "root" "qaidvoid" ];
  boot.supportedFilesystems = [ "ntfs" ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

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

  programs.dconf.enable = true;

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

  environment.shells = with pkgs; [ nushell fish ];

  users.defaultUserShell = pkgs.nushell;
  # programs.bash = {
  #   interactiveShellInit = ''
  #     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  #     then
  #       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #     fi
  #   '';
  # };

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.earlyoom = {
      enable = true;
      enableNotifications = true;
      extraArgs = [ "-g" "--avoid" "(^|/)(vesktop|firefox|niri)$" ];
  };

  system.stateVersion = "24.05";
}
