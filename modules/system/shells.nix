{
  config,
  lib,
  pkgs,
  defaults,
  ...
}:
let
  shellPkg = pkgs.${defaults.defaultShell};
in
{
  options.shells.enable = lib.mkEnableOption "Enable shells";

  config = lib.mkIf config.shells.enable {
    environment.shells = [ shellPkg ];

    programs.${defaults.defaultShell}.enable = true;
    users.defaultUserShell = shellPkg;
  };
}
