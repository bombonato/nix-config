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

  environment.gnome.excludePackages = with pkgs; [
    gnome-bluetooth
    cheese # webcam
    epiphany # web browser
    #gedit # text editor
    #eog # image viewer
    totem # video player
    yelp # help viewer
    geary # email client
    evince # document viewer
    simple-scan # document scanner
    gnome-calendar # calendar
    gnome-contacts # contacts
    gnome-maps # maps
    gnome-music # music
    gnome-photos # photos
    gnome-tour # tour app
    gnome-font-viewer #no need
    gnome-user-docs
    gnome-weather #weather app
  ];
}
