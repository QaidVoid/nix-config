{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
  ];

  options.dms.enable = lib.mkEnableOption "Enable DankMaterialShell";

  config = lib.mkIf config.dms.enable {
    programs.dank-material-shell = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      quickshell = {
        package = inputs.quickshell.packages.${pkgs.system}.default;
      };
      enableVPN = false;
    };
  };
}
