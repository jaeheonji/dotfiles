{ pkgs, ... }: {
  home.packages = with pkgs; [ procs ];

  home.file.".config/btop/themes/catppuccin_mocha.theme" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme";
      hash = "sha256-KnXUnp2sAolP7XOpNhX2g8m26josrqfTycPIBifS90Y=";
    };
  };

  programs.btop = {
    enable = true;

    settings = {
      color_theme = "catppuccin_mocha.theme";
      theme_background = false;
    };
  };
}