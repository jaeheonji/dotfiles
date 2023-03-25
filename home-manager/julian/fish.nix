{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "catppuccin";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "main";
          sha256 = "sha256-wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
        };
      }
    ];

    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
}