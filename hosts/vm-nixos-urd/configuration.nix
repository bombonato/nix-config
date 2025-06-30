# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/base.nix
      ../modules/users.nix
      ../modules/desktop.nix
      ../modules/wm-gnome.nix
      # ../modules/wm-deepin.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enable flakes

  # Opcional, mas recomendado: Mapeia o 'nixpkgs' do flake registry para o mesmo
  # nixpkgs que o seu sistema está usando. Isso garante consistência ao executar
  # comandos como `nix shell nixpkgs#vim`.
  #nix.registry.nixpkgs.flake = config.nix.nixPath."nixpkgs/nixpkgs-25.05";

  networking.hostName = lib.mkDefault "nixos-urd"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # QEMU Guest Agent
  services.qemuGuest.enable = lib.mkDefault true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  ## SOUND
  #services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  security.rtkit.enable = true;
  #security.polkit.enable = true;
  #security.sudo-rs.enable = true;
  # sudo: /run/current-system/sw/bin/sudo must be owned by uid 0 and have the setuid bit set

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # programs.firefox.enable = true;

  ## HEALTHY
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +3";
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    ## Basics
    vim
    wget
    openssl
    bash

    ## Hardware
    pciutils
    usbutils

    ## GPU
    clinfo
    nvtopPackages.amd
    amdgpu_top
    # mesa
    mesa-demos
    # Vulkan
    vulkan-tools # vkcube --gpu_number 0
    # ### virtio3d
    # libglvnd
    # libva
    # vaapiVdpau
    libva-utils

    ## Network
    lsof

    ## CLI
    neofetch

    ## Devel
    git # dev, Nix Flakes, etc

    ## Nix
    nixos-rebuild-ng
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  ## Remote Access
  # Spice
  # Habilite o spice-vdagent para clipboard, resolução dinâmica, etc.
  services.spice-vdagentd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    #settings.PasswordAuthentication = false;
    #settings.KbdInteractiveAuthentication = false;
  };
  #programs.ssh.startAgent = true;

  ## FIREWALL
  networking.firewall.allowPing = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22 # SSH
    3389 # RDP
    5900 # VNC
    8080 # Web Unprivilegied
  ];
  networking.firewall.allowedUDPPorts = [
    3389 # RDP
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

