{
  description = "F3.Nix";

  inputs = {
    # Nix ecosystem
    # https://nixos.org/manual/nixpkgs/stable/
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    ## Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## (sops) My Secrets Configuration
    my-secrets = {
      # `shallow=1` argument in the url ensures that only the most recent revision of the target repository is downloaded.
      url = "git+ssh://git@github.com/bombonato/my-secrets.git?shallow=1";
      ## To access direct the filesystem (good to test and debug before commit secrets)
      # url = "path:/home/myusername/my-secrets";
      # Ensures that this Flake does not have its own inputs to evaluate
      # flake = false;
      inputs = { };
    };
  };

  outputs =
    { nixpkgs
    , nixpkgs-stable
    , home-manager
    , ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # OVERLAY: Add a "Layer" to stable packages
      # Stable NixPkgs Overlay
      stable-overlay = _: prev: {
        stable = import nixpkgs-stable {
          # Ensures that the 'stable' package set is built for the
          # same system as the main 'unstable' package set.
          inherit (prev) system;
          # Allows non-free packages from the stable channel to
          # also be accessed via `pkgs.stable.unfree`.
          config.allowUnfree = true;
        };
      };

      # Supported systems
      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      # Formatting style using official Nix formatter
      # Run with: nix fmt Or nixpkgs-fmt .
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Flake checks
      # Run with: nix flake check (use --keep-going=true to report as much as possible)
      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          mkChecker =
            { name
            , nativeBuildInputs
            , text
            ,
            }:
            pkgs.stdenvNoCC.mkDerivation {
              inherit nativeBuildInputs;

              name = "${name}-check";
              dontBuild = true;
              src = ./.;
              doCheck = true;
              checkPhase = text;
              installPhase = ''
                mkdir "$out"
              '';
            };
        in
        {
          deadnix = mkChecker {
            name = "deadnix";
            nativeBuildInputs = with pkgs; [ deadnix ];
            text = ''
              deadnix -f
            '';
          };
          statix = mkChecker {
            name = "statix";
            nativeBuildInputs = with pkgs; [ statix ];
            text = ''
              statix check
            '';
          };
        }
      );

      # NixOS Configuration entrypoints
      nixosConfigurations = {
        ## Workstations
        # sudo nixos-rebuild switch --flake . # if configurationName == hostname
        # sudo nixos-rebuild boot --flake '.#<hostname>' # or '.#<nixosConfiguration_variable_name>'
        # sudo nixos-rebuild switch --flake '.#<hostname>'
        # nix build '.#nixosConfigurations.<hostname>.config.system.build.topLevel'
        nixos-urd = lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [
            # Apply overlay in all System
            { nixpkgs.overlays = [ stable-overlay ]; }

            # Main host configuration
            ./hosts/vm-nixos-urd/configuration.nix

            # inputs.home-manager.nixosModules.default
          ];
        };
      };

      ## Home-Manager Configuration
      homeConfigurations = {
        "fabio" = home-manager.lib.homeManagerConfiguration {
          # inherit pkgs;
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            # Apply overlay in Home Manager
            { nixpkgs.overlays = [ stable-overlay ]; }
            ./home/fabio/home.nix
          ];
        };
      };
    };
}
