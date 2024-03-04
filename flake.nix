{
  description = "NixOS Configs by Aditya";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      proxmox = nixpkgs.lib.nixosSystem {
        modules = [ 
          ./hosts/proxmox/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aditya.imports = [
              ./users/aditya/home.nix
            ];
          }
        ];
      };
      
      virtualbox = nixpkgs.lib.nixosSystem {
        modules = [ 
          ./hosts/virtualbox/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aditya.imports = [
              ./users/aditya/home.nix
            ];
          }
        ];
      };
    };
  };
}
