{ pkgs, ... }: {
  home.file.".local/share/navi" = {
    source = ../../config/navi;
    recursive = true;
  };

  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  };
}