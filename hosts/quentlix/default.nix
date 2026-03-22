{ inputs, ... }:
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

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    nvidia = {
      open = false;
      modesetting = {
        enable = true;
      };
      nvidiaSettings = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:16:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  xorg = {
    enable = true;
    autorun = false;
    displayManager.type = "startx";
    windowManager.type = "i3";
    desktopManager.type = "xfce";
  };

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
  sunshine.enable = true;
  vaultwarden.enable = true;
  virtualization.enable = true;

  programs.direnv.enable = true;
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  services.tailscale.enable = true;

  # AULA F75
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="258a", ATTR{idProduct}=="010c", MODE="0666"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="258a", ATTR{idProduct}=="010c", MODE="0666"
  '';

  system.stateVersion = "25.11";
}
