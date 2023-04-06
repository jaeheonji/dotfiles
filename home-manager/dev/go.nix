{ pkgs, ... }: {
  home.packages = with pkgs; [ gopls ];

  programs.go = {
    enable = true;
    goPath = ".local/share/go"
  };
}