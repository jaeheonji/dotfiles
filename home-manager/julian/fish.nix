{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "catppuccin",
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "main";
          sha256 = "eeb8173a5110254b128c047849ee7f5ef5eef71758ecb69ed68a30e50a75c45f";
        };
      }
    ];

    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
}