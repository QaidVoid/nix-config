{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    enableZshIntegration = true;
  };
}
