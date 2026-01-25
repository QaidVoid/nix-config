{ config, lib, ... }:
{
  options.theme.enable = lib.mkEnableOption "Enable theme";

  config = lib.mkIf config.theme.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };
  };
}
