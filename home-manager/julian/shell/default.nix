{ pkgs, ... }: {
  imports = [
    ./fish.nix
    ./nushell.nix
  ];

  programs = {
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
