# { config, pkgs, ... }: {
{ pkgs, ... }: {
  ## GNOME
  # Enable the GNOME Desktop Environment.
  ## Stable channel
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  ## Unstable channel
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    gnome = {
      gnome-initial-setup.enable = true;

      gnome-keyring.enable = true;

      # this should allow gnome calculator to convert currencies
      glib-networking.enable = true;

      # Activate gnome-remote-destop support in Gnome
      gnome-remote-desktop.enable = true;
    };
  };

  # Swaylock
  # programs.swaylock.enable = true;
  # security.pam.services.swaylock = {
  #   enableGnomeKeyring = true;
  # };

  environment.systemPackages = with pkgs; [
    #   gnome-session
    gnome-remote-desktop
  ];

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
