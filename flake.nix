{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-amdgpu-fix.url = "github:NixOS/nixpkgs/pull/484928/head";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    niri.url = "github:sodiboo/niri-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { home-manager, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      # Overlay for amdgpu fix from PR #484928
      amdgpu-overlay = final: prev: {
        inherit (inputs.nixpkgs-amdgpu-fix.legacyPackages.${final.system}) xf86-video-amdgpu;
      };

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
            { nixpkgs.overlays = [ amdgpu-overlay ]; }
            inputs.catppuccin.nixosModules.catppuccin
            inputs.sops-nix.nixosModules.sops
            ./hosts/${hostName}
          ];
        };

      # Function to generate a Home Manager configuration for a host
      mkHomeConfiguration =
        hostName:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/${hostName}/home.nix ];
        };

    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkNixosSystem;
      homeConfigurations = nixpkgs.lib.genAttrs hosts (hostName: mkHomeConfiguration hostName);
    };
}
