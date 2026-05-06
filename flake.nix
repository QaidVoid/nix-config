{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { home-manager, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      hosts = [
        "quentlix"
        "zenlix"
      ];

      # Function to generate a NixOS configuration for a host
      mkNixosSystem =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = []; }
            inputs.catppuccin.nixosModules.catppuccin
            inputs.sops-nix.nixosModules.sops
            inputs.mangowm.nixosModules.mango
            ./hosts/${hostName}
          ];
        };

      # Function to generate a Home Manager configuration for a host
      mkHomeConfiguration =
        hostName:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [];
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/${hostName}/home.nix ];
        };

    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkNixosSystem;
      homeConfigurations = nixpkgs.lib.genAttrs hosts (hostName: mkHomeConfiguration hostName);
    };
}
