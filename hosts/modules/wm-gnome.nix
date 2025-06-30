{ config, pkgs, ... }: {
  ## GNOME
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.gnome.gnome-initial-setup.enable = true;

  # Swaylock
  # programs.swaylock.enable = true;
  # security.pam.services.swaylock = {
  #   enableGnomeKeyring = true;
  # };

  services.gnome.gnome-keyring.enable = true;
  # this should allow gnome calculator to convert currencies
  services.gnome.glib-networking.enable = true;

  environment.systemPackages = with pkgs; [
  #   gnome-session
    gnome-remote-desktop
  ];

  services.gnome.gnome-remote-desktop.enable = true;

  systemd.services."gnome-remote-desktop".wantedBy = [ "graphical.target" ];
}
