{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  nixpkgs.config.allowUnfree = true;
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
    mise
    mold
    niri-unstable
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

  # services.xserver = {
  #   enable = true;
  #
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       dmenu # application launcher most people use
  #       i3status # gives you the default i3 status bar
  #       i3lock # default i3 screen locker
  #     ];
  #   };
  # };
  #
  # services.displayManager.gdm.enable = true;
}
