# nix-config
NixOS Configuration

- NixOS Configuration with Flakes and Home Manager support

## Links

Info

- [Home Manager - github](https://github.com/nix-community/home-manager)
- [Home Manager - Manual](https://nix-community.github.io/home-manager/)
- [Home Manager - Options](https://home-manager-options.extranix.com/)

Repositories

- https://mynixos.com/
- https://search.nixos.org/packages
- https://flakehub.com/
- https://www.nixhub.io/


## Structure

General structure for the nixos configurationm

```
nix-config/
├── flake.nix
├── home/
│   ├── <username>/home.nix           # Arquivo principal que importa os outros
│   └── modules/
│       ├── cli.nix                     # Configs de apps de linha de comando (htop, fd, etc)
│       ├── git.nix                     # Configs do Git
│       ├── shell.nix                   # Configs do Zsh, Bash, Starship, Fish, ...
│       ├── desktop.nix                 # Configs especificas para Desktop usuario
│       └── browser.nix                 # Configs de browser: Chrome, Brave, etc
└── hosts/
    ├── <host>/configuration.nix      # Arquivo principal que importa os outros
    └── modules/
        ├── base.nix                    # Configs base (timezone, locale, etc)
        ├── desktop.nix                 # Configs de ambiente gráfico no sistema (GNOME, KDE, Deepin, ...)
        └── users.nix                   # Onde o seu usuário é definido para criação
```