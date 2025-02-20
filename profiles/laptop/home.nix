{ pkgs, config, lib, opts, zen-browser, ... }:
let
  configdir = "${config.home.homeDirectory}/nix-config";
  sym = config.lib.file.mkOutOfStoreSymlink;
in {
  imports = [
    ../../modules/user
  ];

  development.enable = true;
  niri.enable = true;
  direnv.enable = true;
  swaylock.enable = true;
  swayidle.enable = true;

  programs.firefox.enable = true;
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox.override {
  #     nativeMessagingHosts = [
  #       pkgs.tridactyl-native
  #     ];
  #   };
  # };

  home.packages = with pkgs; [
    ani-cli
    cargo-udeps
    chromium
    cloudflared
    dblab
    diesel-cli
    distrobox
    dua
    file
    ghostty
    git-cliff
    helix
    helix-gpt
    hyperfine
    gnumake
    gurk-rs
    mongodb-compass
    nushell
    openjdk
    playerctl
    rocketchat-desktop
    rio
    sccache
    slurp
    telegram-desktop
    typst
    typstfmt
    tinymist
    vesktop
    xh
    wf-recorder
    xwayland-satellite
    zathura
    zen-browser.packages.${opts.system}.default

    (writeShellApplication {
      name = "toggle-theme";
      runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
      text =
        ''
          if [[ -f "$(home-manager generations | head -1 | rg -o '/[^ ]*')/specialisation/light-theme/activate" ]]; then
            "$(home-manager generations | head -1 | rg -o '/[^ ]*')"/specialisation/light-theme/activate
          else
            "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate
          fi
        '';
    })
  ];

  xdg.desktopEntries.Helix = {
      name = "helix";
      noDisplay = true;
  };
  xdg.desktopEntries.nvim = {
      name = "nvim";
      noDisplay = true;
  };
  xdg.desktopEntries.zathura = {
      name = "zathura";
      noDisplay = true;
  };

  xdg.desktopEntries.fish = {
    name = "fish";
    noDisplay = true;
  };
  xdg.desktopEntries.nixos-manual = {
    name = "nixos-manual";
    noDisplay = true;
  };

  # home.file = {
  #   ".config/foot".source = sym "${configdir}/dotfiles/foot";
  #   ".config/niri".source = sym "${configdir}/dotfiles/niri";
  # };

}
