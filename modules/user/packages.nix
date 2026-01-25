{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.userPackages.enable = lib.mkEnableOption "Enable user packages";

  config = lib.mkIf config.userPackages.enable {
    home.packages = with pkgs; [
      ani-cli
      aseprite
      b3sum
      biome
      brave
      blender
      bun
      burpsuite
      cargo-edit
      cargo-generate
      cargo-msrv
      cargo-update
      claude-code
      cmake
      dig
      discord-ptb
      dua
      firefox-devedition
      fish
      font-manager
      gimp
      godot
      gopls
      github-cli
      harper
      heroic
      hydra-check
      imagemagick
      inkscape
      just-formatter
      just-lsp
      (localstack.override {
        python3 = python3.override {
          packageOverrides = self: super: {
            localstack-ext = super.localstack-ext.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
                self.pyjwt
              ];
            });
          };
        };
      })
      lua-language-server
      mdbook
      nautilus
      nixd
      nixfmt
      nix-index
      nodejs_latest
      opencode
      pnpm
      qbittorrent
      racket
      rclone
      rustup
      rust-code-analysis
      semgrep
      signal-desktop
      slack
      slurp
      steel
      stylua
      svelte-language-server
      telegram-desktop
      tiled
      tridactyl-native
      typescript
      typescript-language-server
      typst
      typstyle
      typst-live
      tailwindcss-language-server
      tree-sitter
      tombi
      uv
      wayvnc
      wezterm
      wiremix
      vscode-langservers-extracted
      xwayland-satellite
      wf-recorder
      yt-dlp
      zathura
      zed-editor
      zoxide
      zls_0_15
    ];

    programs.obs-studio.enable = true;
  };
}
