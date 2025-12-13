{ inputs, pkgs, ... }:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
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
}
