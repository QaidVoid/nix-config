{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./mpv.nix
    ./niri.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh.nix
    ./wl-utils.nix
  ];

  # fish.enable = true;
  git.enable = true;
  mpv.enable = true;
  tmux.enable = true;
  yazi.enable = true;
  zsh.enable = false;

  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.fzf.enable = true;
  programs.starship.enable = true;
}
