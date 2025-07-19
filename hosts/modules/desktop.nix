# { pkgs, ... }: {
_: {
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

}
