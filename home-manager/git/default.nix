{ pkgs, ... }: {
  imports = [
    ./gh.nix
    ./git.nix
    ./gitui.nix
  ];
}