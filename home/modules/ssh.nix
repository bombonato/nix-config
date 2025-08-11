{ inputs, config, ... }:
{
    programs.ssh = {

        enable = true;

        matchBlocks ={
          "github" = {
            host = "github.com";
            hostName = "github.com";
            user = "git";
            # forwardAgent = true;
            identitiesOnly = true;
            # identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
            identityFile = [
                "${config.home.homeDirectory}/.ssh/id_ed25519_github_bombonato"
            ];
          };
        };
    };
};