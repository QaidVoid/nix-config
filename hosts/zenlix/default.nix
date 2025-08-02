{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  networking.hostName = "zenlix";

  users.users.qaidvoid = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "video" ];
  };

  system.stateVersion = "25.11";
}
