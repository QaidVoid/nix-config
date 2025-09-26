{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ani-cli
    b3sum
    biome
    brave
    bun
    burpsuite
    cargo-edit
    cargo-generate
    cargo-msrv
    cargo-update
    cmake
    dig
    dua
    firefox-devedition
    fish
    github-cli
    harper
    heroic
    hydra-check
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
    mako
    mdbook
    opencode
    nautilus
    niri
    nixd
    nixfmt
    nix-index
    nodejs_latest
    pnpm
    qbittorrent
    racket
    rustup
    rust-code-analysis
    semgrep
    slurp
    steel
    stylua
    swaybg
    swayidle
    swayimg
    swaylock
    telegram-desktop
    tridactyl-native
    typescript
    typescript-language-server
    tailwindcss-language-server
    tree-sitter
    tombi
    vesktop
    wezterm
    wiremix
    vscode-langservers-extracted
    xwayland-satellite
    wf-recorder
    yt-dlp
    zed-editor
    zoxide
    zls_0_15
  ];

  programs.obs-studio.enable = true;

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        layer = "overlay";
      };
    };
  };

  programs.starship = {
    enable = true;
      settings = {
        add_newline = true;
        character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  services.mako.enable = true;
  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 270;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds' -t 5000";
        }
        {
          timeout = 300;
          command = lock;
        }
        {
          timeout = 305;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };
}
