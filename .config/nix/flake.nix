{
  description = "NixOS system flake config for laptop and home server";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16 = {
      url = "github:SenchoPens/base16.nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ags, base16, home-manager, nixvim, stylix }@inputs: {
    nixosConfigurations = {
      nixClam = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          base16.nixosModule
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          ./common.nix
          ./laptop.nix
          ./home.nix
          ./stylix.nix
        ];
      };
      nixBrick = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./common.nix
          ./server.nix
        ];
      };
    };
  };
}
