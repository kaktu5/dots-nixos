{
  description = "My favourite NixOS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      bobrowniki = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bober = import ./home/bober/home.nix;
          }
        ];
      };
    };
  };
}
