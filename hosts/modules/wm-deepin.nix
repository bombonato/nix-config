{ config, pkgs, ... }: {



  ## DEEPIN
  # Enable the Deepin Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true; # Login Manager
  services.xserver.desktopManager.deepin.enable = true;
  # services.deepin.dde-daemon.enable = true;
}
