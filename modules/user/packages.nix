{
  config,
  lib,
  pkgs,
  ...
}:
let
  scrinio = pkgs.callPackage ../../pkgs/scrinio.nix { };
  helium-browser = pkgs.callPackage ../../pkgs/helium-browser.nix { };

  # GTX 1060 is Pascal (sm_61); upstream ollama-cuda no longer compiles CUDA
  # kernels for that arch. Override cudaArches to add it back. If FlashAttention
  # fails on Pascal (48 KB shared memory limit), set OLLAMA_FLASH_ATTENTION=0.
  ollama-pascal = pkgs.ollama.override {
    acceleration = "cuda";
    cudaArches = [
      "sm_61"
      "sm_75"
      "sm_80"
      "sm_86"
      "sm_89"
      "sm_90"
    ];
  };
in
{
  options.userPackages.enable = lib.mkEnableOption "Enable user packages";

  config = lib.mkIf config.userPackages.enable {
    home.packages = with pkgs; [
      act
      xmodmap
      ani-cli
      aseprite
      xrandr
      b3sum
      bitcoind
      biome
      brave
      blender
      browsh
      bun
      burpsuite
      cargo-edit
      cargo-generate
      cargo-msrv
      cargo-update
      claude-code
      cmake
      deno
      devenv
      dig
      discord
      dua
      eww
      firefox-devedition
      fish
      font-manager
      gimp
      godot
      gopls
      github-cli
      gpu-screen-recorder
      grim
      harper
      helium-browser
      heroic
      hydra-check
      imagemagick
      inkscape
      insomnia
      just-formatter
      just-lsp
      keepassxc
      libnotify
      lua-language-server
      mdbook
      nixd
      nixfmt
      nix-index
      nodejs_latest
      ollama-pascal
      opencode
      pnpm
      qbittorrent
      racket
      rclone
      rofi
      rustup
      rust-code-analysis
      scrinio
      semgrep
      signal-desktop
      slack
      slurp
      steel
      stylua
      svelte-language-server
      swaybg
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
      # upwork
      uv
      wayvnc
      wezterm
      wiremix
      vscode-langservers-extracted
      xwayland-satellite
      wireshark
      yt-dlp
      zathura
      zed-editor
      zoxide
      zls
      vscode-langservers-extracted
      sccache
      zellij
    ];
  };
}
