# { pkgs, ... }: {
{ ... }: {
    ## CORE
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.variant =  "altgr-intl";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";
    # services.xserver.xkb.options = "ctrl:nocaps";

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

    ## DEEPIN
    # Enable the Deepin Desktop Environment.
    #services.xserver.displayManager.lightdm.enable = true;
    #services.xserver.desktopManager.deepin.enable = true;
    # TEMP: Desabilitar deepin-anything-module devido Kernel Novo
    #services.xserver.desktopManager.deepin.deepin-anything.enable = false;
}