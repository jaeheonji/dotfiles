{ pkgs, ... }: {
  home.packages = with pkgs; [ zenith procs ];
}