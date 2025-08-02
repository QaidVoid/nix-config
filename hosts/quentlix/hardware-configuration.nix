{ config, lib, ... }:
{
  imports = [];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-782eca9f-2f9e-4d2c-97a3-e8efc9b78853";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "subvol=nixos" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/luks-782eca9f-2f9e-4d2c-97a3-e8efc9b78853";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A210-C16E";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  boot.initrd.luks.devices."luks-782eca9f-2f9e-4d2c-97a3-e8efc9b78853".device = "/dev/disk/by-uuid/782eca9f-2f9e-4d2c-97a3-e8efc9b78853";

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
