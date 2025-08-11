{ inputs,... }:
let
  secretsPath = builtins.toString inputs.my-secrets;
in
{
  # imports = [
  #   inputs.sops-nix.nixosModules.sops
  # ];
  # Configuração do sops-nix
  sops = {
    defaultSopsFile = "${secretsPath}/secrets/nixos/nixos-urd.yaml";
    validateSopsFiles = false;

    # Habilita a descriptografia usando a chave SSH do host.
    age = { 
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # This is using an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };

    # Define um segredo específico e nomeado para a senha do usuário.
    # Isso torna o acesso ao segredo mais claro e robusto.
    # secrets.initialPassword = {
    #   # Aponta para o arquivo de segredos no flake 'my-secrets'.
    #   path = "${inputs.my-secrets.secrets.nixos.nixos-urd}";
    #   # Especifica o caminho exato para o valor dentro do arquivo YAML.
    #   key = "nixos.nixos-urd.users.fabio.initialHashedPassword";
    # };

    # Destination
    # the actual specification of the secrets.
    secrets."nixos/nixos-urd/users/fabio/initialHashedPassword" = { };
    secrets."nixos/nixos-urd/users/fabio/hashedPassword" = { };
  };
}
