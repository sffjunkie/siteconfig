{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index = {
      url = "github:nix-community/nix-index";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qde = {
      url = "github:sffjunkie/qde/develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    bash-prompt = ''\n\[\033[1;34m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] '';
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (import ./lib { inherit lib inputs; });

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      hostCommonModules = [
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
      ];

      homeCommonModules = [
        home-manager.nixosModules.default
        {
          config = {
            home-manager = {
              useUserPackages = true;

              extraSpecialArgs = {
                inherit inputs;
              };

              sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.nixvim.homeManagerModules.nixvim
              ];
            };
          };
        }
      ];

      mkSystem =
        { baseModules, ... }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit lib;
          };

          modules = baseModules ++ hostCommonModules ++ homeCommonModules;
        };

    in
    {
      nixosConfigurations = {
        # Security
        pinky = mkSystem {
          baseModules = [
            ./configuration/host/pinky
            ./configuration/user/sysadmin/host

            {
              config.home-manager.users.sysadmin = import ./configuration/user/sysadmin/home;
            }
          ];
        };

        # Services
        thebrain = mkSystem {
          baseModules = [
            ./configuration/host/thebrain
            ./configuration/user/sysadmin/host

            {
              config.home-manager.users.sysadmin = import ./configuration/user/sysadmin/home;
            }
          ];
        };

        # Workstation
        furrball = mkSystem {
          baseModules = [
            ./configuration/host/furrball
            ./configuration/user/sdk/host
            ./configuration/user/sysadmin/host

            {
              config.home-manager.users.sdk = import ./configuration/user/sdk/home;
              config.home-manager.users.sysadmin = import ./configuration/user/sysadmin/home;
            }

            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.nixos-hardware.nixosModules.common-gpu-amd

            inputs.nix-index-database.nixosModules.nix-index

            inputs.qde.nixosModules.default
          ];
        };

        # Storage
        babs = mkSystem {
          baseModules = [
            ./configuration/host/babs
            ./configuration/user/sysadmin/host

            {
              config.home-manager.users.sysadmin = import ./configuration/user/sysadmin/home;
            }

            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
          ];
        };

        # Laptop
        buster = mkSystem {
          baseModules = [
            ./configuration/host/buster
            ./configuration/user/sdk/host
            ./configuration/user/sysadmin/host

            {
              config.home-manager.users.sdk = import ./configuration/user/sdk/home;
              # TODO: Fix sdk_buster
              # // (import ./configuration/user/sdk_buster/home);
              config.home-manager.users.sysadmin = import ./configuration/user/sysadmin/home;
            }

            inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ];
        };

        # Installer ISO
        installer = mkSystem {
          baseModules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./installer/looniversity-minimal.nix
            {
              config.home-manager.users.nixos = import ./configuration/user/nixos/home;
            }
          ];
        };
      };

      # Generic development shells
      # The default 'nix' shell includes scripts to build nixos systems
      # using nix-ouptut-monitor
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = import ./devshell/nix { inherit pkgs; };
          go = import ./devshell/go { inherit pkgs; };
          python = import ./devshell/python { inherit pkgs; };
          rust = import ./devshell/rust { inherit pkgs; };
          net = import ./devshell/net { inherit pkgs; };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # The nix devShell above adds a `nut` function which runs the tests
      # under the `unitTests` attribute
      unitTests = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        lib.test.run {
          dir = ./test;
          inherit lib pkgs; # Needed by test functions
          # Optional attrs
          # include = ".*_test\.nix";
          # exclude = "";
          # quiet = false;
        }
      );
    };
}
