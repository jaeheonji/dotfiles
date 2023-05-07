# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  hostname = "russian-blue";
  username = "meow";
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  nixpkgs = {
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
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
      options = "--delete-older-than 7d";
    };
  };

  networking.hostName = "${hostname}";

  services = {
    nix-daemon.enable = true;
  };

  # https://nixos.wiki/wiki/Command_Shell
  programs.fish.enable = true;

  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.enable
  homebrew = {
    enable = true;
    casks = [
      "spotify"
      "visual-studio-code"
    ];
  };

  environment = {
    systemPackages = with pkgs; [ home-manager ];
    shells = with pkgs; [ fish ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
  };

  users.users = {
    "${username}" = {
      name = "${username}";
      home = "/Users/${username}";
      shell = pkgs.fish;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      ${username} = import ../../home-manager/standard-darwin.nix;
    };
  };
}
