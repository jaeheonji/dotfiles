{ pkgs, ... }: {
  home.file.".config/zellij" = {
    source = ../../config/zellij;
    recursive = true;
  };

  programs.zellij = {
    enable = true;
  };
}
