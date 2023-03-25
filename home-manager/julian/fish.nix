{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
}