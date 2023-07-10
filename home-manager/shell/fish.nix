{ pkgs, ... }: {
  home.sessionVariables = {
    SHELL = "fish";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    shellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';
  };
}