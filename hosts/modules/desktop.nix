# { pkgs, ... }: {
{ ... }: {
  ## CORE
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "altgr-intl";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # services.xserver.xkb.options = "ctrl:nocaps";

}
