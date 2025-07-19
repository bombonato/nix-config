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
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      # inherit (self) outputs;
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # OVERLAY: Add a "Layer" to stable packages
      stable-overlay = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
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
      # Run with: nix fmt
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
            ./hosts/vm-nixos-urd/configuration.nix
            # inputs.home-manager.nixosModules.default
          ];
        };
      };

      ## Home-Manager Configuration
      homeConfigurations = {
        "fabio" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
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
