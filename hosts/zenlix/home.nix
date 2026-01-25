{ pkgs, ... }:
{
  imports = [
    ../../modules/user
  ];

  home.username = "qaidvoid";
  home.homeDirectory = "/home/qaidvoid";

  cli.enable = true;
  cli.enableStarship = true;
  cli.enableYazi = true;
  userPackages.enable = true;
  userTheme.enable = true;
  userXdg.enable = true;

  home.stateVersion = "25.05";
}
