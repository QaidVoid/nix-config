{ lib, config, ... }:
{
  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      shellAliases = {
        cat = "bat";
        vi = "nvim";
        vim = "nvim";
      };

      initExtra = ''
        bindkey -v
        export KEYTIMEOUT=1
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}