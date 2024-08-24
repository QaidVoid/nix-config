{ lib, config, ... }:
{
  options = {
    git.enable = lib.mkEnableOption "Enable git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      aliases = {
        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate --date=short";
      };

      delta = {
        enable = true;
        options = {
          hyperlinks = true;
          navigate = true;
          light = false;
          side-by-side = false;
          line-numbers = true;
        };
      };

      signing = {
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      extraConfig = {
        color.ui = true;
        merge.conflictStyle = "diff3";
        diff.colorMoved = "default";
        pull.ff = "only";
        pull.rebase = true;

        github.user = "qaidvoid";
        init.defaultBranch = "main";
        gpg.format = "ssh";
        user.useConfigOnly = true;
        gpg.ssh.allowedSigners = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDEXRNZrMiWdJn9Fdbjnjz+D60UfpR8jA3CC6Hs23n3c
        '';
      };

      userName = "Rabindra Dhakal";
      userEmail = "contact@qaidvoid.dev";
    };
  };
}
