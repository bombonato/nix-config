# { pkgs, ... }: {
{ config, pkgs, ... }: {

  config.home.packages = with pkgs; [
        brave
  ];

  # nixpkgs.config.chromium.commandLineArgs = "--gtk-version=4";
  
  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  # };
}