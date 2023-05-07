{ pkgs, ... }:
let
  catppuccin-mocha = ".config/alacritty/catppuccin/catppuccin-mocha.yml";
in {
  programs.alacritty = {
    enable = true;

    settings = {
      import = ["~/${catppuccin-mocha}"];

      env.TERM = "xterm-256color";

      window = {
        decorations = "buttonless";
        option_as_alt = "OnlyLeft";
      };

      font = {
        normal.family = "CaskaydiaCove Nerd Font Mono";
      };

      selection.save_to_clipboard = true;
    };
  };

  home.file."${catppuccin-mocha}" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-mocha.yml";
      hash = "sha256-28Tvtf8A/rx40J9PKXH6NL3h/OKfn3TQT1K9G8iWCkM=";
    };
  };
}