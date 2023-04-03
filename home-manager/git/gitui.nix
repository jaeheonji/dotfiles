{ pkgs, ... }: {
  programs.gitui = {
    enable = true;
    theme = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/gitui/main/theme/mocha.ron";
      hash = "sha256-dgZsvEI5oKhNZfmpipQiF6PDXXaUCvlrhR2ilfCMCZI=";
    };
  }; 
}