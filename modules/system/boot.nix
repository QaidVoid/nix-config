{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.boot.enable = lib.mkEnableOption "Enable boot configuration";

  config = lib.mkIf config.boot.enable {
    boot.tmp.cleanOnBoot = true;
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_12;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
