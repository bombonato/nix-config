_: {
  ## DEEPIN
  # Enable the Deepin Desktop Environment.
  services = {
    xserver = {
      displayManager.lightdm.enable = true; # Login Manager
      desktopManager.deepin.enable = true;
    };
  };
}
