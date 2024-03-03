# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/proxmox.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "charali";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kathmandu";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aditya = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDs5rFHygPS8uCK+LJ4XOpenVrGk6ZUzNLb6w9eFiUI8 adityathebe"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aria
    bat
    bottom
    curl
    dig
    du-dust
    eza
    gcc # for neovim (probably required by tree sitter)
    git
    gnumake
    go
    jq
    killall
    neovim
    ripgrep
    tmux
    watch
    wget
    zsh
    zsh-powerlevel10k
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [ 
      "${XDG_BIN_HOME}"
      "$/opt/bin"
      "$HOME/.local/bin"
      "$XDG_DATA_HOME/go/bin"
    ];

    #####################
    # Clean up home dir #
    #####################
    AZURE_CONFIG_DIR = "$XDG_DATA_HOME/azure";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    GOPATH = "$XDG_DATA_HOME/go";
    LESSHISTFILE = "-";
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";

    GIT_EDITOR = "nvim";
    EDITOR = "nvim";
  };

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };

    zsh = {
      enable = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
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
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

