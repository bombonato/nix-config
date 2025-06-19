{
    description = "F3.Nix";

    inputs = {
        # https://nixos.org/manual/nixpkgs/stable/
        # branch: nixos-25.05
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
     };

    outputs = { self, nixpkgs, ... }:
        let
            lib = nixpkgs.lib;
        in {
            # NixOS configuration entrypoints
            nixosConfigurations = {
                ## Workstations
                # sudo nixos-rebuild switch --flake . # if configurationName == hostname
                # sudo nixos-rebuild boot --flake '.#<hostname>' # ou '.#<nixosConfiguration_variable_name>'
                # sudo nixos-rebuild switch --flake '.#<hostname>'
                # nix build '.#nixosConfigurations.<hostname>.config.system.build.topLevel'
                nixos-urd = lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [ ./hosts/vm-nixos-urd/configuration.nix ];
                };
            };
        };

}