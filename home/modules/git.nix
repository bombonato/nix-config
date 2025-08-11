{ inputs, ... }:
{
  programs.git = {
    enable = true;
    userName = inputs.my-secrets.user.git;
    userEmail = inputs.my-secrets.email.git;
    extraConfig = {
      # Magit-forge configuration
      github.user = inputs.my-secrets.user.github;
      gitlab.user = inputs.my-secrets.user.gitlab;
    };
  };

}
