{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ erdtree ];

    file.".config/erdtree" = {
      source = ../../config/erdtree;
      recursive = true;
    };
  };
}