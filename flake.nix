{
  description = "NixOS configuration of mevatron";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-master,
    nixos-hardware,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    username = "wlucas";
    pkgs-unstable = import nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
    };
    pkgs-master = import nixpkgs-master {
        system = system;
        config.allowUnfree = true;
    };
   in {
    nixosConfigurations = {
      vbox = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
            inherit pkgs-unstable pkgs-master;
        };

        modules = [
          ./hosts/vbox

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = {
                inherit inputs pkgs-unstable pkgs-master;
            };
            home-manager.users.${username} = import ./home;
          }
        ];
      };

      io = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
            inherit pkgs-unstable pkgs-master;
        };

        modules = [
          nixos-hardware.nixosModules.lenovo-legion-16aph8
          ./hosts/io

          # add the following inline module definition
          #   here, all parameters of modules are passed to overlays
          (args: { nixpkgs.overlays = import ./overlays args; })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = {
                inherit inputs pkgs-unstable pkgs-master;
            };
            home-manager.users.${username} = import ./home;
          }
        ];
      };

      jupiter = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
            inherit pkgs-unstable pkgs-master;
        };

        modules = [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          ./hosts/jupiter

          # add the following inline module definition
          #   here, all parameters of modules are passed to overlays
          (args: { nixpkgs.overlays = import ./overlays args; })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = {
                inherit inputs pkgs-unstable pkgs-master;
            };
            home-manager.users.${username} = import ./home;
          }
        ];
      };
    };
  };
}