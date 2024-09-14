{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./niri.nix
    ./yazi.nix
    ./zsh.nix
    ./wl-utils.nix
  ];

  fish.enable = true;
  git.enable = true;
  yazi.enable = true;
  zsh.enable = false;

  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };

  programs.fzf.enable = true;
  programs.starship.enable = true;
}
