{ pkgs, ... }: {
  imports = [
    ./ssh.nix

    # Shell
    ./fish.nix
    ./nushell.nix

    # Integration
    ./zoxide.nix
    ./starship.nix
    ./direnv.nix
  ];
}
