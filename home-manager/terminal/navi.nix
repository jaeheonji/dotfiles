{ pkgs, ... }: {
  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  }
}