{ pkgs, ... }:
let
  options = import (./. + "/../../options.nix");
in
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.users.${options.username}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
