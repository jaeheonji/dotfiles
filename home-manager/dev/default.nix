{ pkgs, ... }: {
  imports = [
    ./rust.nix
  ];

  home.packages = with pkgs; [ gcc ];
}