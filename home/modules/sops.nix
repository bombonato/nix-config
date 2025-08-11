{ inputs, config, ... }:
let
    homeDirectory = config.home.homeDirectory;
    secretsPath = builtins.toString inputs.my-secrets;
in
{
  # Configuration via home.nix
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # defaultSopsFile = ./my-secrets/users/fabio/secrets.yaml; #TODO refactor to removre static user
    defaultSopsFile = "${secretsPath}/secrets/users/fabio.yaml"; #TODO refactor to removre static user
    validateSopsFiles = false;

    age = {
        keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
        # It's also possible to use a ssh key, but only when it has no password:
        # age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    };

    # Destination to secrets
    secrets = {
        "private_keys/ssh/github-bombonato" = { 
            path = "${homeDirectory}/.ssh/id_ed25519_github_bombonato";
            mode = "0600";
        };
    };
  };
}