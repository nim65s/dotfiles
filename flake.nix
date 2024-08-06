{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
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
            rbw = prev.rbw.override (super: {
              rustPlatform = super.rustPlatform // {
                buildRustPackage =
                  args:
                  super.rustPlatform.buildRustPackage (
                    args
                    // {
                      version = "1.12.1";
                      src = final.fetchFromGitHub {
                        owner = "doy";
                        repo = "rbw";
                        rev = "1.12.1";
                        hash = "sha256-+1kalFyhk2UL+iVzuFLDsSSTudrd4QpXw+3O4J+KsLc=";
                      };
                      cargoHash = "sha256-cKbbsDb449WANGT+x8APhzs+hf5SR3RBsCBWDNceRMA=";
                    }
                  );
              };
            });
            sway = final.nur.repos.nim65s.sway-lone-titlebar;
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
