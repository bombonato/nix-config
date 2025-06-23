{ config, pkgs, ... }: {
  ## DEEPIN
  # Enable the Deepin Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true; # Login Manager
  services.xserver.desktopManager.deepin.enable = true;
  # TEMP: Desabilitar deepin-anything-module devido Kernel Novo
  #services.xserver.desktopManager.deepin.deepin-anything.enable = false;
}
