# { pkgs, ... }: {
{ ... }: {
  programs.git = {
    enable = true;
    userName = "bombonato";
    userEmail = "fabio.bombonato@gmail.com";
    extraConfig = {
      # Magit-forge configuration
      github.user = "bombonato";
      gitlab.user = "fabio.bombonato";
    };
  };
}
