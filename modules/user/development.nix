{ pkgs, lib, config, ... }:
{
  options = {
    development.enable = lib.mkEnableOption "Enable development tools";
    direnv.enable = lib.mkEnableOption "Enable nix-direnv";
  };

  config = lib.mkMerge [
    (lib.mkIf config.development.enable {
      home.packages = with pkgs; [
        # WEB
        biome
        bun
        emmet-language-server
        marksman
        nodejs
        pnpm
        sqls
        tailwindcss
        tailwindcss-language-server
        typescript-language-server
        vscode-langservers-extracted

        clang-tools
        go
        gopls
        lua-language-server
        nil
        omnisharp-roslyn
        rustup
        taplo
        zig
        zls
      ];
    })

    (lib.mkIf config.direnv.enable {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    })
  ];
}
