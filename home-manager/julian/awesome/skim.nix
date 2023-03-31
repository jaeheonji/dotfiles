{ pkgs, ... }: {
  programs.skim = {
    enable = true;

    enableFishIntegration = true;
  };
}