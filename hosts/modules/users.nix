{ pkgs, ... }: {

  ## SHELL
  # programs.bash.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.bash;

  nix.settings.trusted-users = [ "root" "@wheel" ]; # Allow remote updates

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabio = {
    initialHashedPassword = "$y$j9T$PFtrZ3M7s4mmAXItIlV9G.$r4WDsdIDgYYS7IcuiUEOeFm8k7K0emKpkqfzldmAOi7";
    isNormalUser = true;
    description = "Fa3io";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "render"
      "input"
      "plugdev"
    ]; # Enable ‘sudo’ for the user.

    # Define o shell de login padrão para este usuário
    shell = pkgs.zsh; # ou pkgs.bash, pkgs.fish, etc.

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrfZGmKcc2xRLXsHuRd0uDgKysPW9JmsoVmBYFoFVVk"
    ];
  };
}
