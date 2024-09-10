{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./niri.nix
    ./yazi.nix
    ./zsh.nix
  ];

  fish.enable = true;
  git.enable = true;
  yazi.enable = true;
  zsh.enable = false;

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
