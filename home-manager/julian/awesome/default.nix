{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./helix.nix
    ./skim.nix
    ./zellij.nix
  ];
}