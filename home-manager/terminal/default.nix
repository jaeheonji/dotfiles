{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./broot.nix
    ./compression.nix
    ./erdtree.nix
    ./fetch.nix
    ./metric.nix
    ./navi.nix
    ./search.nix
    ./zellij.nix

    ./markdown
  ];
}