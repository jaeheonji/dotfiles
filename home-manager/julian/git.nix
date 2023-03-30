{ pkgs, ... }: {
  programs = {
    gh.enable = true;

    git = {
      enable = true;

      userEmail = "atx6419@gmail.com";
      userName = "Jae-Heon Ji";

      extraConfig = {
        init = { defaultBranch = "main"; };
      };

      delta = {
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
        };
      };
    };

    gitui = {
      enable = true;
      theme = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/gitui/main/theme/mocha.ron";
        hash = "sha256-dgZsvEI5oKhNZfmpipQiF6PDXXaUCvlrhR2ilfCMCZI=";
      };
    };
  };
}