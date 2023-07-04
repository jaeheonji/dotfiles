{ pkgs, ... }: {
  home.packages = with pkgs; [ openssh ];

  programs.ssh = {
    enable = true;
  };
}
