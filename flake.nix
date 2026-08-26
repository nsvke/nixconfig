{
  description = "enes's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    modal-shell = {
      url = "github:nsvke/modal";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
      let
        flakeDir = "/home/enes/.config/nixos";
      in  
    {
      nixosConfigurations = {
        rog = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration/rog
          ];
        };
      };

      homeConfigurations = {
        "enes@rog" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs flakeDir; };
          modules = [
            ./home
          ];
        };
      };
    };
}
