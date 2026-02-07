{ ... }:

{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./pipewire.nix
    ./postgresql.nix
    ./security.nix
    ./services.nix
    ./sops.nix
    ./shells.nix
    ./steam.nix
    ./sunshine.nix
    ./theme.nix
    ./vaultwarden.nix
    ./virtualization.nix
    ./xorg.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics.enable = true;

  programs.nano.enable = false;

  programs.gnupg.agent = {
    enable = true;
  };
}
