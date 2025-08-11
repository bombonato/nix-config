{ inputs
, config
, lib
, ...
}:
let
  secretsPath = builtins.toString inputs.my-secrets;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  ### MODULE CONTRACT ###
  ## Contract definitions required for this module
  ## namespace: my-host
  options.my-host.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable initial SOPS Encryptation config to specific host";
    };
    defaultSopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to file containing the sops encryptation file (YAML) for specific host";
    };
  };

  ### MODULE CONFIG ###
  config = lib.mkIf config.my-host.sops.enable {
    # sops-nix configurations
    sops = {
      inherit (config.my-host.sops) defaultSopsFile;
      validateSopsFiles = false;

      # Enables decryption using the host's SSH key.
      age = {
        # This will automatically import SSH keys as age keys
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        # This is using an age key that is expected to already be in the filesystem
        keyFile = "/var/lib/sops-nix/key.txt";
        # This will generate a new key if the key specified above does not exist
        generateKey = true;
      };
    };

    sops.secrets = lib.mkMerge [
      {
        "password/initialHashedPassword" = {
          sopsFile = "${secretsPath}/secrets/common/users.yaml";
          owner = "root";
          group = "root";
          mode = "0400";
          neededForUsers = true;
        };
      }
    ];
  };
}
