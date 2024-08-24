{ pkgs, lib, config, ... }:
{
  options = {
    development.enable = lib.mkEnableOption "Enable development tools";
  };

  config = lib.mkIf config.development.enable {
    home.packages = with pkgs; [
      # WEB
      biome
      bun
      emmet-language-server
      marksman
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
      rustup
      taplo
      zig
      zls
    ];
  };
}
