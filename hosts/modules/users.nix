{ pkgs, ... }: {

  ## SHELL
  # programs.bash.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.bash;

  nix.settings.trusted-users = [ "root" "@wheel" ]; # Allow remote updates

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabio = {
    isNormalUser = true;
    description = "Fa3io";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "render" "input" ]; # Enable ‘sudo’ for the user.

    # Define o shell de login padrão para este usuário
    shell = pkgs.zsh; # ou pkgs.bash, pkgs.fish, etc.

    #openssh.authorizedKeys.keys = [
    #	"YOUR SSH PUBLIC KEY"
    #];
  };
}
