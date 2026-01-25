{ config, lib, ... }:
{
  options.gaming.enable = lib.mkEnableOption "Enable gaming profile";

  config = lib.mkIf config.gaming.enable {
    steam.enable = true;
  };
}
