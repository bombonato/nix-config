{
    description = "F3.Nix";

    inputs = {
        # https://nixos.org/manual/nixpkgs/stable/
        # branch: nixos-25.05
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        home-manager.url = "github:nix-community/home-manager/release-25.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
     };

    outputs = { self, nixpkgs, home-manager, ... }@inputs :
        let
            # inherit (self) outputs;
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in {
            # NixOS configuration entrypoints
            nixosConfigurations = {
                ## Workstations
                # sudo nixos-rebuild switch --flake . # if configurationName == hostname
                # sudo nixos-rebuild boot --flake '.#<hostname>' # or '.#<nixosConfiguration_variable_name>'
                # sudo nixos-rebuild switch --flake '.#<hostname>'
                # nix build '.#nixosConfigurations.<hostname>.config.system.build.topLevel'
                nixos-urd = lib.nixosSystem {
                    specialArgs = { inherit system inputs; };
                    modules = [ 
                        ./hosts/vm-nixos-urd/configuration.nix 
                        # inputs.home-manager.nixosModules.default
                    ];
                };
            };

            ## Home-Manager configuration
            homeConfigurations = {
                "fabio" = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit inputs; };
                    modules = [ ./home/fabio/home.nix ];
                };
            };
        };

}