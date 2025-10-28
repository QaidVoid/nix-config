{ inputs, pkgs, ... }:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
    quickshell = {
      package = inputs.quickshell.packages.${pkgs.system}.default;
    };
    enableColorPicker = false;
    enableVPN = false;
    enableBrightnessControl = false; # ddcutil works better
  };
}
