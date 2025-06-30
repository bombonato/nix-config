{ pkgs, ... }: {
  # { ... }: {
  ## CORE
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "altgr-intl";

  ## Remote Access
  # Sunshine
  # Habilita o servidor de streaming Sunshine
  # services.sunshine.enable = true;
  # services.sunshine.openFirewall = true;
  # # Permite que o Sunshine acesse os inputs, necessário para controle remoto
  # hardware.uinput.enable = true;

}
