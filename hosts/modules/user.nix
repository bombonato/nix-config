{ pkgs
, inputs
, config
, lib
, ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  ### MODULE CONTRACT ###
  ## Contract definitions required for this module
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
    nickName = lib.mkOption {
      type = lib.types.str;
      description = "Your nick name description to the user";
      example = "Darth Vader";
    };
    initialHashedPassword = lib.mkOption {
      type = lib.types.str;
      default = null;
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

  ### MODULE CONFIG ###
  config = lib.mkIf config.my-host.user.enable {

    ## SHELL
    # programs.bash.enable = true;
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.bash;

    nix.settings.trusted-users = [
      "root"
      "@wheel"
      config.my-host.user.name
    ]; # Allow remote updates

    users = {
      # mutableUsers = false; # required for pwd to be set via sops during system activation

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.${config.my-host.user.name} = {
        # populate initialHashedPassword Options from user.nix module
        inherit (config.my-host.user) initialHashedPassword;
        isNormalUser = true;
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
        shell = pkgs.zsh; # or pkgs.bash, pkgs.fish, etc.

        openssh.authorizedKeys.keys = config.my-host.user.sshAuthorizedKeys;
      };
    };
  };
}
