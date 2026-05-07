{ defaults, ... }:
{
  imports = [
    ../../modules/user
  ];

  home.username = defaults.username;
  home.homeDirectory = defaults.homeDirectory;

  cli.enable = true;
  cli.enableStarship = true;
  cli.enableYazi = true;
  mpv.enable = true;
  userPackages.enable = true;
  userTheme.enable = true;
  userXdg.enable = true;
  zen.enable = true;

  home.stateVersion = "25.05";
}
