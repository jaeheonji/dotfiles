{ pkgs, ... }: {
  home.packages = with pkgs; [ fd ripgrep ];

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
  };
}