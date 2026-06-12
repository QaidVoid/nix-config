{
  config,
  lib,
  options,
  pkgs,
  defaults,
  ...
}:
let
  shellPkg = pkgs.${defaults.defaultShell};
  shellName = defaults.defaultShell;
in
{
  options.shells.enable = lib.mkEnableOption "Enable shells";

  config = lib.mkIf config.shells.enable (
    {
      environment.shells = [ shellPkg ];
      users.defaultUserShell = shellPkg;
    }
    // lib.optionalAttrs (options.programs ? ${shellName}) {
      programs.${shellName}.enable = true;
    }
  );
}
