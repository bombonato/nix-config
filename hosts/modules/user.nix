{ pkgs, inputs, config, lib, ... }:
let
  inherit (config.home) homeDirectory;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  ## Define Contract Requirements for this module
  ## namespace: my-host
  options.my-host.user = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable initial User config to host";
    };
    name = lib.mkOption {
      type = lib.types.str;
      description = "Your user name to initial host config";
      example = "joedoe";
    };
    nicknName = lib.mkOption {
      type = lib.types.str;
      description = "Your nick name description to the user";
      example = "Darth Vader";
    };
    initialHashedPassword = lib.mkOption {
      type = lib.types.str;
      description = "initial and generic user password hash for host config (mkpasswd)";
      example = "GY6I2QXe/sR ... BfZTr.";
    };
    sshAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Your SSH public key to host access";
      example = "[ \"ssh-ed25519 AAAA....XXXX\" ];";
    };
  };


  ## SHELL
  # programs.bash.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.bash;

  nix.settings.trusted-users = [ "root" "@wheel" ]; # Allow remote updates

  # sops.secrets = {
  #   initialHashedPassword = {
  #     neededForUsers = true; # decrypt the secret to /run/secrets-for-users/, so it can be used to create the user
  #     owner = config.users.users.fabio.name;
  #     inherit (config.users.users.fabio) group;
  #   };
  #   # "nixos/nixos-urd/users/fabio/hashedPassword" = {
  #   #   neededForUsers = true; # decrypt the secret to /run/secrets-for-users/, so it can be used to create the user
  #   #   owner = config.users.users.fabio.name;
  #   #   inherit (config.users.users.fabio) group;
  #   # };
  # };
  users = {
    # mutableUsers = false; # required for pwd to be set via sops during system activation

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.fabio = {
    users.config.my-host.user.name = {
      # initialHashedPassword = "cat ${config.sops.secrets.initialHashedPassword.path}";
      initialHashedPassword = config.my-host.user.initialHashedPassword;
      # hashedPasswordFile = config.sops.secrets."users/fabio/hashedPassword".path;
      isNormalUser = true;
      # description = inputs.my-secrets.user.nickName;
      description = config.my-host.user.nickName;
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

      # openssh.authorizedKeys.keys = [
      #   # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrfZGmKcc2xRLXsHuRd0uDgKysPW9JmsoVmBYFoFVVk"
      #   ${config.my-host.user.authorizedKeys};
      # ];
      authorizedKeys.keys = [
        (${config.my-host.user.authorizedKeys} or [ ])
      ];
    };
  };
}
