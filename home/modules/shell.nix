{ config
, pkgs
, lib
, ...
}:
let
  # My shell aliases
  myAliases = {
    ls = "eza --icons -l -T -L=1";
    la = "eza --icons -l -T -L=1 --git -a";
    du = "dust";
    fetch = "disfetch";
    nrs = "sudo nixos-rebuild switch --flake ~/nix-config";
    hms = "home-manager switch --flake ~/nix-config";
  };
in
{
  home.packages = with pkgs; [
    neofetch # fancier system info than pfetch and disfetch
    eza # ls replacement
    tree # cli dir tree viewer
    fzf # fuzzy search
    ncdu # TUI disk usage
    dust # disk usage
    direnv
    nix-direnv
  ];

  ## Dir
  programs = {
    ## DirEnv
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    ## ZSH
    zsh = {
      enable = true;
      # Recommended location for zsh files
      dotDir = "${config.home.homeDirectory}/zsh";
      shellAliases = myAliases;

      # Plugins
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      # Changes to a directory if you type its name
      autocd = true;
      # Enables integration with Oh My Zsh (without installing OMZ fully).
      # This gives us declarative access to its plugins and themes.
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        # theme = "agnoster";
        # theme = "robbyrussell";
      };
      # initExtra = ''
      # PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
      #  %F{green}→%f "
      # RPROMPT="%F{red}▂%f%F{yellow}▄%f%F{green}▆%f%F{cyan}█%f%F{blue}▆%f%F{magenta}▄%f%F{white}▂%f"
      # [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
      # bindkey '^P' history-beginning-search-backward
      # bindkey '^N' history-beginning-search-forward
      # '';
      # Histórico
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreDups = true;
        share = true;
      };
    };

    ## STARSHIP
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    ## EZA (ls replacement)
    eza = {
      enable = true;
      # enableFishIntegration = true;
      # enableBashIntegration = true;
      enableZshIntegration = true;
      # extraOptions = ["-l" "--icons" "--git" "-a"];
    };

    ## ZOXIDE (better cd)
    ## - z => go to most access direcotory
    ## - z ~ => go to home
    ## - z + <name> => go to directory that best match name
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    ## BTop (better htop)
    btop = {
      enable = true;
      settings = {
        color_theme = lib.mkForce "gruvbox_dark";
        round_corners = true;
        theme_background = true;
        vim_keys = true;
      };
    };
  };

  xdg.configFile."starship.toml" = {
    # source = ./path/para/seu/starship.toml; # If you prefer a separate file
    text = ''
      # Usa um preset de prompt com ícones e cores
      # Você pode encontrar outros em: https://starship.rs/presets/
      "$schema" = 'https://starship.rs/config-schema.json'

      # Insere uma nova linha entre os prompts
      add_newline = true

      # --- MÓDULO CUSTOMIZADO PARA O ÍCONE DO NIXOS ---
      [custom.nixos]
      # Descrição não funcional, apenas para clareza
      description = "Mostra o ícone do NixOS"
      # O comando pode ser qualquer coisa que retorne sucesso (exit code 0)
      command = "echo"
      # O ícone do NixOS (requer Nerd Font). Código: nf-dev-nixos
      symbol = " "
      # Define a cor do ícone (usando nomes de cores do Starship)
      style = "blue bold"
      # O formato do output. '$symbol' insere o ícone definido acima.
      format = "[$symbol]($style)"
      # Mostra o ícone em qualquer diretório
      when = "true"
    '';
  };
}
