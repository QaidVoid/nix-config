{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.shells.enable = lib.mkEnableOption "Enable shells";

  config = lib.mkIf config.shells.enable {
    environment.shells = with pkgs; [ fish ];

    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };
}
