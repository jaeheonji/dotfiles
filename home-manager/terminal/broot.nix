{ pkgs, ... }: {
  programs.broot = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      modal = true;

      verbs = [
        {
          invocation = "edit";
          shortcut = "e";
          key = "ctrl-e";
          execution = "$EDITOR {file}";
          leave_broot = false;
        }
      ];
    };
  };
}