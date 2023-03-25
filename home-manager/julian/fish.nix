{ pkgs, ... }: {
  home.sessionVariables = {
    SHELL = "fish";
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
}