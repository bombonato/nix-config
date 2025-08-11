{ pkgs, config, ... }:
{
  imports = [
    ../modules/sops.nix
    ../modules/ssh.nix
    ../modules/git.nix
    ../modules/shell.nix
    ../modules/desktop.nix
    ../modules/browser.nix
  ];

  ### user-specific definitions for modules contract
  ### namespace: my-user
  my-user.ssh.github = {
    enable = true;
    identityFileName = "id_ed25519_github";
  };

  # Secrets destination
  sops.secrets = {
    "keys/ssh/github" = {
      path = "${config.home.homeDirectory}/.ssh/${config.my-user.ssh.github.identityFileName}";
      mode = "0600";
    };
    "keys/ssh/githubPub" = {
      path = "${config.home.homeDirectory}/.ssh/${config.my-user.ssh.github.identityFileName}.pub";
      mode = "0640";
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "fabio";
    homeDirectory = "/home/fabio";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      ## Devel
      gh
      code-server

      ## AI
      gemini-cli

      ## Security
      sops
      age

      ## Nix
      nixfmt-rfc-style
      nixpkgs-fmt

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/myusername/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      SHELL = "zsh";
      # TERMINAL = "";
      # VISUAL = "nvim";
      EDITOR = "vim";
      SOPS_EDITOR = "vim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
