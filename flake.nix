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
    numtide.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-master,
    nixos-hardware,
    numtide,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    username = "wlucas";
    handyPackage = pkgs-unstable.handy;
    handyForceCpu = pkgs-unstable.writeShellApplication {
      name = "handy-force-cpu";
      runtimeInputs = with pkgs-unstable; [ coreutils jq ];
      text = ''
        settings_dir="$HOME/.local/share/com.pais.handy"
        settings_file="$settings_dir/settings_store.json"

        if [[ ! -f "$settings_file" ]]; then
          exit 0
        fi

        temporary_file="$(mktemp "$settings_dir/settings_store.json.XXXXXX")"
        trap 'rm -f "$temporary_file"' EXIT

        jq \
          '.transcribe_accelerator = "cpu"
           | .ort_accelerator = "cpu"
           | .transcribe_gpu_device = -1' \
          "$settings_file" > "$temporary_file"

        mv "$temporary_file" "$settings_file"
        trap - EXIT
      '';
    };
    handyHomeModule = {
      systemd.user.services.handy = {
        Unit = {
          Description = "Handy speech-to-text";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStartPre = "${handyForceCpu}/bin/handy-force-cpu";
          ExecStart = "${handyPackage}/bin/handy --start-hidden";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
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
                inherit pkgs-unstable pkgs-master;
                "llm-agents" = numtide;
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

          {
            boot.kernelModules = [ "uinput" ];
            services.udev.extraRules = ''
              KERNEL=="uinput", GROUP="input", MODE="0660"
            '';
            users.users.${username}.extraGroups = [ "input" ];
          }

          # add the following inline module definition
          #   here, all parameters of modules are passed to overlays
          (args: { nixpkgs.overlays = import ./overlays args; })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = {
                inherit pkgs-unstable pkgs-master;
                "llm-agents" = numtide;
            };
            home-manager.users.${username} = {
              imports = [ ./home handyHomeModule ];
            };
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

          {
            boot.kernelModules = [ "uinput" ];
            services.udev.extraRules = ''
              KERNEL=="uinput", GROUP="input", MODE="0660"
            '';
            users.users.${username}.extraGroups = [ "input" ];
          }

          # add the following inline module definition
          #   here, all parameters of modules are passed to overlays
          (args: { nixpkgs.overlays = import ./overlays args; })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = {
                inherit pkgs-unstable pkgs-master;
                "llm-agents" = numtide;
            };
            home-manager.users.${username} = {
              imports = [ ./home handyHomeModule ];
            };
          }
        ];
      };
    };
  };
}
