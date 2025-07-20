{ config, lib, pkgs, ... }: {
  ## Desktop Choice Personalization (custom)
  options.desktop.environment = lib.mkOption {
    type = lib.types.enum [ "gnome" "deepin" "none" ]; # <== Avaliable Options
    default = "gnome";
    description = "Desktop Enviroment to activate";
  };

  # Conditional import the correct module to desktop variable choice (custom)
  imports = [
    # sintax: (import ./file) { args }
    (lib.mkIf (config.desktop.environment == "gnome") (
      (import ./wm-gnome.nix) { inherit pkgs; }
    ))
    (lib.mkIf (config.desktop.environment == "deepin") (
      (import ./wm-deepin.nix) { }
    ))
  ];

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

    # Sunshine
    # Habilita o servidor de streaming Sunshine
    # services.sunshine.enable = true;
    # services.sunshine.openFirewall = true;

    # # Permite que o Sunshine acesse os inputs, necessário para controle remoto
    # hardware.uinput.enable = true;
  };
}
