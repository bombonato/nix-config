{ config
, lib
, pkgs
, ...
}:
{
  ### MODULE CONTRACT ###
  ## Desktop Choice Personalization (custom)
  options.my-host.desktop.environment = lib.mkOption {
    type = lib.types.enum [
      "gnome"
      "deepin"
      "none"
    ]; # <== Avaliable desktop Options to use
    default = "gnome";
    description = "Desktop Enviroment to activate";
  };

  # Conditional import the correct module to desktop variable choice (custom)
  imports = [
    # sintax: (import ./file) { args }
    (lib.mkIf (config.my-host.desktop.environment == "gnome") (
      (import ./wm-gnome.nix) { inherit pkgs; }
    ))
    (lib.mkIf (config.my-host.desktop.environment == "deepin") ((import ./wm-deepin.nix) { }))
  ];

  ### MODULE CONFIG ###
  config = {

    ## CORE
    services = {
      xserver = {
        # Enable the X11 windowing system.
        enable = true;
        # Configure keymap in X11
        xkb.layout = "us";
        xkb.variant = "altgr-intl";
      };
    };

    ## Remote Access

    ## Sunshine
    # Enable streaming Sunshine service
    # services.sunshine.enable = true;
    # services.sunshine.openFirewall = true;

    ## Allows Sunshine to access the inputs, required for remote control.
    # hardware.uinput.enable = true;
  };
}
