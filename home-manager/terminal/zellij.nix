{ pkgs, ... }: {
  # configuration
  home.file.".config/zellij" = {
    source = ../../config/zellij;
    recursive = true;
  };

  # monocle plugins for zellij
  home.file.".local/share/zellij/plugins/monocle.wasm" = {
    source = pkgs.fetchurl {
      url = "https://github.com/imsnif/monocle/releases/download/0.37.2/monocle.wasm";
      hash = "sha256-wEftVp/4b3WASxVun+p35Gr9KkobOSoqvg6kGXrztw4=";
    };
  };

  programs.zellij = {
    enable = true;
  };
}
