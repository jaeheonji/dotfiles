{ pkgs, ... }: {
  imports = [
    ./fish.nix
    ./nushell.nix
  ];

  programs = {
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
