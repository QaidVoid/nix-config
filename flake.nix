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
    opts = import (./. + "/options.nix");
    system = opts.system;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      ${opts.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit opts; };
        modules = [
            (./. + "/profiles" + ("/" + opts.profile) + "/configuration.nix")
          ];
      };
    };
    homeConfigurations = {
      ${opts.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit opts; };
        modules = [
            (./. + "/profiles" + ("/" + opts.profile) + "/home.nix")
          ];
      };
    };
  };
}
