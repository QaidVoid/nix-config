{ config, lib, ... }:
{
  options.development.enable = lib.mkEnableOption "Enable development profile";

  config = lib.mkIf config.development.enable {

  };
}
