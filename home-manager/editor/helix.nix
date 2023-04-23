{ pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.helix = {
    enable = true;

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        true-color = true;
        bufferline = "multiple";
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      editor.indent-guides = {
        render = true;
      };
      editor.lsp = {
        display-inlay-hints = true;
      };
      editor.soft-wrap = {
        enable = true;
      };
    };
  };
}