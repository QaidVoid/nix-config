{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    options = import (./. + "/options.nix");
    system = options.system;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      ${options.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
            (./. + "/profiles" + ("/" + options.profile))
          ];
      };
    };
    homeConfigurations = {
      ${options.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
            (./. + "/profiles" + ("/" + options.profile) + "/home.nix")
          ];
      };
    };
  };
}
