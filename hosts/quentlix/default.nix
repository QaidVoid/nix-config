{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  sops.defaultSopsFile = ./secrets.yaml;

  nix.settings.trusted-users = [ "root" "qaidvoid" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  networking.hostName = "quentlix";

  users.users.qaidvoid = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "video" "podman" "wireshark" ];
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

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  pipewire.enable = true;
  postgresql.enable = true;
  steam.enable = true;
  vaultwarden.enable = true;

  programs.direnv.enable = true;
  programs.wireshark.enable = true;

  programs.nix-ld.enable = true;

  services.tailscale.enable = true;

  system.stateVersion = "25.11";
}
