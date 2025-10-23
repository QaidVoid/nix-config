{
  pkgs,
  inputs,
  config,
  ...
}:
{
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
    cmake
    dig
    dua
    firefox-devedition
    fish
    gimp
    godot
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
    tiled
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
    zathura
    zed-editor
    zoxide
    zls_0_15
  ];

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      AutoFillAddressEnabled = true;
      AutoFillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    profiles.default = {
      containersForce = true;
      containers = {
        Personal = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "green";
          icon = "briefcase";
          id = 2;
        };
      };
      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles.default.containers;
        in
        {
          Personal = {
            id = "7deea877-f5f5-4ddb-a871-15f1b862e4b2";
            container = containers.Personal.id;
            position = 1000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 26;
                  green = 27;
                  blue = 38;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
            };
          };
          Work = {
            id = "34258d6c-4589-437d-8312-165787664c3a";
            container = containers.Work.id;
            position = 1001;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 89;
                  green = 131;
                  blue = 120;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
            };
          };
        };
    };
  };

  programs.obs-studio.enable = true;
  programs.fuzzel.enable = true;

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

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
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
