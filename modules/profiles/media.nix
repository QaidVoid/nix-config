{ config, lib, ... }:
{
  options.media.enable = lib.mkEnableOption "Enable media profile";

  config = lib.mkIf config.media.enable {

  };
}
