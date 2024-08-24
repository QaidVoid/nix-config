{ pkgs, lib, config, opts, ... }:
{
  options = {
    docker.enable = lib.mkEnableOption "Enable docker";
  };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    users.users.${opts.username}.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
