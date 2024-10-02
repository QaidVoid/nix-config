{ opts, ... }:
{
  imports = [
    ./development.nix
    ./packages.nix
    ./theme.nix
    ./programs
    ./services
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = opts.username;
  home.homeDirectory = "/home/" + opts.username;

  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
