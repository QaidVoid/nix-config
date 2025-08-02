{ pkgs, ... }:
{
  imports = [
    ../../modules/user
  ];

  home.username = "qaidvoid";
  home.homeDirectory = "/home/qaidvoid";

  home.stateVersion = "25.05";
}
