{
  description = "My dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nim65s-dotfiles.cachix.org"
      "https://nim65s-nur.cachix.org"
      "https://rycee.cachix.org"
      "https://cache.lix.systems"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nim65s-dotfiles.cachix.org-1:6vuY5z8YGzfjrssfcxb3DuH50DC1l562U0BIGMxnClg="
      "nim65s-nur.cachix.org-1:V3uaUnDnkWYgPDZaXpoe/KIbX5913GWfkazhHVDYPoU="
      "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        localSystem = system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            nur = import nur {
              nurpkgs = prev;
              pkgs = prev;
            };
          })
          (final: prev: {
            sway-lone-titlebar = prev.sway.override {
              sway-unwrapped =
                (prev.sway-unwrapped.overrideAttrs (
                  finalAttrs: previousAttrs: {
                    patches = final.lib.lists.take 2 previousAttrs.patches ++ final.lib.lists.drop 3 previousAttrs.patches;
                    src = final.fetchFromGitHub {
                      owner = "nim65s";
                      repo = "sway";
                      rev = "fa4c1cdc50b1cf28acac4e599b750a65e788602e";
                      hash = "sha256-NbmjZKuu1c+m293Vzi35EEjBEWaOfp0F0pz7rtKesJU=";
                    };
                  }
                )).override
                  {
                    wlroots = prev.wlroots.overrideAttrs {
                      version = "0.18.0-dev";
                      src = final.fetchFromGitLab {
                        domain = "gitlab.freedesktop.org";
                        owner = "wlroots";
                        repo = "wlroots";
                        rev = "48721bca656556606275a5e776066a2f00822e92";
                        hash = "sha256-PUx4RZiLbWineoAvZk7kuUBXRFI15vfxLna49LUR8+s=";
                      };
                      patches = [ ];
                    };
                  };
                };
          })
        ];
      };
    in
    {
      homeConfigurations = {
        "gsaurel@asahi" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/asahi/home.nix ];
        };
        "gsaurel@upepesanke" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/upepesanke/home.nix ];
        };
        "nim@yupa" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/yupa/home.nix ];
        };
      };
      nixosConfigurations = {
        fix = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nix/fix/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/fix/home.nix;
            }
          ];
        };
        loon = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nix/loon/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/loon/home.nix;
            }
          ];
        };
        hattorixos = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./nix/hattorixos/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/loon/home.nix; # follow loon cfg
            }
          ];
        };
      };
    };
}
