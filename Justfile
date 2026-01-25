hostname := `hostname`
prev_system := `realpath /run/current-system`
prev_home := `realpath ~/.local/state/nix/profiles/home-manager`

default:
  @just --list

[group('nix')]
switch:
  nixos-rebuild build --flake .#{{hostname}} |& nom
  nixos-rebuild switch --flake .#{{hostname}} --sudo
  dix {{prev_system}} /run/current-system

[group('nix')]
home:
  home-manager switch --flake .#{{hostname}} |& nom
  dix {{prev_home}} ~/.local/state/nix/profiles/home-manager

[group('nix')]
update:
  nix flake update
  @just switch
  @just home
