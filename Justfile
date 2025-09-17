set shell := ["nu", "-c"]
hostname := `hostname`

default:
  @just --list

[group('nix')]
switch:
  let prev = (realpath /run/current-system); \
  echo $prev; \
  nixos-rebuild build --flake .#{{hostname}} o+e>| nom; \
  doas ./result/activate; \
  dix $prev /run/current-system

[group('nix')]
home:
  let prev = (realpath ~/.local/state/nix/profiles/home-manager); \
  home-manager switch --flake .#{{hostname}} o+e>| nom; \
  dix $prev ~/.local/state/nix/profiles/home-manager
