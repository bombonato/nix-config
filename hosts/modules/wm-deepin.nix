# { config, pkgs, ... }: {
_: {



  ## DEEPIN
  # Enable the Deepin Desktop Environment.
  services = {
    xserver = {
      displayManager.lightdm.enable = true; # Login Manager
      desktopManager.deepin.enable = true;
    };
    # deepin.dde-daemon.enable = true;
  };
}
