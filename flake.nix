{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, zen-browser, ... }:
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
            catppuccin.nixosModules.catppuccin
            (./. + "/profiles" + ("/" + opts.profile) + "/configuration.nix")
          ];
      };
    };
    homeConfigurations = {
      ${opts.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit opts; inherit zen-browser; };
        modules = [
            catppuccin.homeManagerModules.catppuccin
            (./. + "/profiles" + ("/" + opts.profile) + "/home.nix")
          ];
      };
    };
  };
}
