{ inputs, config, ... }:
let
  inherit (config.home) homeDirectory username;
  secretsPath = builtins.toString inputs.my-secrets;
in
{
  # Configuration via home.nix
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretsPath}/secrets/users/${username}.yaml";
    validateSopsFiles = false;

    age = {
      keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
      # It's also possible to use a ssh key, but only when it has no password:
      # age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    };
  };
}
