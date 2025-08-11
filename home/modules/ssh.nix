{ config, lib, ... }:
let
  inherit (config.home) homeDirectory;
in
{
  ### MODULE CONTRACT ###
  ## Contract definitions required for this module
  ## namespace: my-user
  options.my-user.ssh = {
    github = {
      # Enable GitHub access over SSH
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GitHub access config in SSH";
      };
      # Need GitHub SSH Key file
      identityFileName = lib.mkOption {
        type = lib.types.str;
        # We don't define a default here, making the option mandatory if enable = true.
        description = "Identity Filename of SSH key to github access";
        example = "id_ed25519_github";
      };
    };
  };

  ### MODULE CONFIG ###
  config = {
    programs.ssh = lib.mkMerge [
      # Requerid section
      {
        enable = true;
      }

      # Optional section
      (lib.mkIf config.my-user.ssh.github.enable {
        matchBlocks = {
          "github" = {
            host = "github.com";
            hostname = "github.com";
            user = "git";
            identitiesOnly = true;
            identityFile = "${homeDirectory}/.ssh/${config.my-user.ssh.github.identityFileName}";
          };
        };
      })
    ];
  };
}
