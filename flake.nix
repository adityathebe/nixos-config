{
  description = "NixOS Configs by Aditya";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = { nixpkgs, ... }: 
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      vm-intel = nixpkgs.lib.nixosSystem {
        modules = [ ./machines/vm-intel.nix ];
      };
      vm-proxmox = nixpkgs.lib.nixosSystem {
        modules = [ ./machines/vm-proxmox.nix ];
      };
    };
  };
}
