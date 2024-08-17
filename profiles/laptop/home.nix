{ pkgs, ... }:
let
  options = import (./. + "/../../options.nix");
in
{
  imports = [
    ../../user/shared
    ../../user/development
    ../../user/zsh
    ../../user/mako
    ../../user/wlsunset
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = options.username;
  home.homeDirectory = "/home/" + options.username;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    chromium
    niri
    protonvpn-gui
    telegram-desktop
    tree
    typst
    typstfmt
    typst-lsp
    vesktop
  ];

  home.file = {
    ".config/foot".source = ../../user/foot;
    ".config/niri".source = ../../user/niri;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
