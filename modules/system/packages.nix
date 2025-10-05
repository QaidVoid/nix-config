{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    android-tools
    bat
    btop
    clang
    clang-tools
    ddcutil
    delta
    distrobox
    dix
    eza
    fastfetch
    fd
    ffmpeg
    file
    gcc
    git
    glib
    gnumake
    go
    helix
    jq
    jujutsu
    just
    libgcc
    mold
    nix-output-monitor
    openssl
    p7zip-rar
    podman-compose
    podman-tui
    ripgrep
    skim
    sops
    tmux
    unzip
    xdg-utils
    wl-clipboard
    zig_0_15
    (pkgs.writeShellScriptBin "sudo" "doas $@")
  ];

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
    defaultEditor = true;
  };
}
