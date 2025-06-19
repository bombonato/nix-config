# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enable flakes

  networking.hostName = lib.mkDefault "nixos-urd"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # QEMU Guest Agent
  services.qemuGuest.enable = lib.mkDefault true; 
 
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # security.pam.services.swaylock = {
  #  enableGnomeKeyring = true;
  #};

  #services.gnome.gnome-keyring.enable = true;
  # this should allow gnome calculator to convert currencies
  #services.gnome.glib-networking.enable = true;

  # Enable the Deepin Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.deepin.enable = true;
  # TEMP: Desabilitar deepin-anything-module devido Kernel Novo
  #services.xserver.desktopManager.deepin.deepin-anything.enable = false;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant =  "altgr-intl";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # services.xserver.xkb.options = "ctrl:nocaps";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
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
  

  nix.settings.trusted-users = [ "root" "@wheel" ]; # Allow remote updates

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabio = {
     isNormalUser = true;
     description = "Fa3io";
     extraGroups = [ "wheel" "networkmanager" "video" "render" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       # tree
     ];
     #openssh.authorizedKeys.keys = [
     #	"YOUR SSH PUBLIC KEY"
     #];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # programs.firefox.enable = true;

  nix.settings.auto-optimise-store = true;

  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +3";
  };

  #programs.nh = {
  #    enable = true;
  #    clean = {
  #      enable = true;
  #      # daily at 6 AM or later 
  #      # (just so that it doesn't GC at midnight like it would with "daily")
  #      dates = "6:00";
  #      extraArgs = lib.strings.concatStringsSep " " [
  #        # remove any generations older than 14 days...
  #        "--keep-since 14d"
  #        # ...but keep at least 7 generations, even if they are older than that.
  #        "--keep 7"
  #        # don't clean gc roots automatically so that direnv can cache the results
  #        "--nogcroots"
  #      ];
  #    };
  #  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     #pkgs.linuxKernel.packages.linux_latest_libre.deepin-anything-module
     ## Basics
     vim
     wget
     openssl
     
     ## Hardware
     pciutils
     usbutils
     
     ## Network
     lsof

     ## CLI
     neofetch
     
     ## Devel
     git # dev, Nix Flakes, etc
     gh
     code-server

     ## Nix
     nixos-rebuild-ng
     nixfmt-rfc-style
     nixpkgs-fmt
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
  	22   # SSH
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

