{ defaults, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  networking.hostName = "zenlix";

  users.users.${defaults.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "video"
    ];
  };

  boot.enable = true;
  fonts.enable = true;
  locale.enable = true;
  networking.enable = true;
  systemPackages.enable = true;
  pipewire.enable = true;
  security.enable = true;
  hardwareServices = {
    enable = true;
    openrgb = false;
    libinput = true;
    bluetooth = true;
    earlyoom = true;
  };
  shells.enable = true;
  theme.enable = true;

  system.stateVersion = "25.11";
}
