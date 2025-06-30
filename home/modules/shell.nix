{ config, pkgs, ... }:
let
  # My shell aliases
  myAliases = {
    ls = "eza --icons -l -T -L=1";
    fetch = "disfetch";
    nrs = "sudo nixos-rebuild switch --flake ~/nix-config";
    hms = "home-manager switch --flake ~/nix-config";
  };
in
{
  home.packages = with pkgs; [
    disfetch
    eza
    tree
    direnv
    nix-direnv
    ghostty
  ];

  ## Dir
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  ## ZSH
  programs.zsh = {
    enable = true;
    # Local recomendado para os arquivos do zsh
    dotDir = ".config/zsh";
    shellAliases = myAliases;

    # Plugins
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    # Muda para um diretório se você digitar o nome dele
    autocd = true;
    # Habilita a integração com o Oh My Zsh (sem instalar o OMZ por completo)
    # Isso nos dá acesso aos seus plugins e temas de forma declarativa
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
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml" = {
    # source = ./path/para/seu/starship.toml; # Se preferir um arquivo separado
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
