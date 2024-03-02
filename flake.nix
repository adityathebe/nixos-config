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
      vm-intel = nixpkgs.lib.nixosSystem {
        modules = [ 
          ./machines/vm-intel.nix 
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
      vm-vbox = nixpkgs.lib.nixosSystem {
        modules = [ ./machines/vm-vbox.nix ];
      };
    };
  };
}
