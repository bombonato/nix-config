# { pkgs, ... }: {
{ config, pkgs, ... }: {

  config.home.packages = with pkgs; [
    brave
  ];

  # nixpkgs.config.chromium.commandLineArgs = "--gtk-version=4";

  config.home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
