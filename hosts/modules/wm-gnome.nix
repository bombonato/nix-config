{ config, pkgs, ... }: {
  ## GNOME
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  security.pam.services.swaylock = {
    enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;
  # this should allow gnome calculator to convert currencies
  services.gnome.glib-networking.enable = true;
}
