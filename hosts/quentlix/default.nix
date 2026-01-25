{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  networking.hostName = "quentlix";

  sops.defaultSopsFile = ./secrets.yaml;
  sops.enable = true;

  nix.settings.trusted-users = [
    "root"
    "qaidvoid"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;

  users.users.qaidvoid = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "video"
      "podman"
      "wireshark"
    ];
    subGidRanges = [
      {
        count = 65536;
        startGid = 100000;
      }
    ];
    subUidRanges = [
      {
        count = 65536;
        startUid = 100000;
      }
    ];
  };

  virtualisation.waydroid = {
    enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
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
    openrgb = true;
    libinput = true;
    bluetooth = true;
    earlyoom = true;
  };
  shells.enable = true;
  theme.enable = true;
  postgresql.enable = true;
  steam.enable = true;
  vaultwarden.enable = true;

  programs.direnv.enable = true;
  programs.wireshark.enable = true;

  programs.nix-ld.enable = true;

  services.tailscale.enable = true;

  system.stateVersion = "25.11";
}
