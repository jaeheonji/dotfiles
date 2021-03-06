# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, modulesPath, ... }:
let
  hostname = "abyssinian";
  username = "meow";
in {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.home-manager.nixosModules.home-manager

    "${modulesPath}/profiles/minimal.nix"
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";

    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # The garbage collector will keep the outputs of non-garbage derivations
      keep-outputs = true;
      # The garbage collector will keep the derivations from which non-garbage store
      keep-derivations = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.hostName = "${hostname}";

  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
    wslConf = {
      automount.root = "/mnt";
      network.hostname = "${hostname}";
    };

    # Enable native Docker support
    docker-native = {
      enable = true;
      addToDockerGroup = true;
    };

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  # https://nixos.wiki/wiki/Command_Shell
  programs.fish.enable = true;

  environment = {
    systemPackages = with pkgs; [ home-manager ];
    shells = with pkgs; [ fish ];
  };

  users.users = {
    "${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      ${username} = import ../../home-manager/standard.nix;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
