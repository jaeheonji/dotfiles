{ pkgs, ... }: {
  programs.git = {
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
}