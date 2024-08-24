{ ... }:
{
  imports = [
    ./git.nix
    ./niri.nix
    ./yazi.nix
    ./zsh.nix
  ];

  git.enable = true;
  yazi.enable = true;
  zsh.enable = true;

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
