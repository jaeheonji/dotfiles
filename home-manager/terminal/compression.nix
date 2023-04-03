{ pkgs, ... }: {
  home.packages = with pkgs; [ 
    # `unzip` is sometimes used in custom scripts
    unzip
    ouch
  ];
}