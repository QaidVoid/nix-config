{ lib, config, pkgs, ... }:
{
  options = {
    fish.enable = lib.mkEnableOption "Enable fish";
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        cat = "bat";
      };
      interactiveShellInit = ''
        set fish_greeting;
        set -g fish_key_bindings fish_vi_key_bindings

        function nixify
          if not test -e ./.envrc
            echo "use nix" > .envrc
            direnv allow
          end

          if not test -e shell.nix -a -e default.nix
            echo "with import <nixpkgs> {}; 
              mkShell {
                nativeBuildInputs = [
                  bashInteractive
                ];
              }" > default.nix
            $EDITOR default.nix
          end
        end

        function flakify
          if not test -e flake.nix
            nix flake new -t github:nix-community/nix-direnv .
          else if not test -e .envrc
            echo "use flake" > .envrc
            direnv allow
          end

          $EDITOR flake.nix
        end
      '';
      plugins = [
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      ];
    };
  };
}
