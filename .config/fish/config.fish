if status is-interactive
    function fish_greeting
        if test "$TERM_PROGRAM" = zed
            echo ""
        else
            fastfetch --config examples/13.jsonc --kitty-icat ~/Pictures/profile-2.png \
                --logo-width 22
        end
    end

    # Environments
    set -gx EDITOR helix
    set -gx VISUAL helix

    set -gx CLAUDE_CONFIG_DIR $HOME/.config/claude

    # Language-specific
    set -gx NPM_CONFIG_CACHE $HOME/.cache/npm
    set -gx GOPATH $HOME/.local/share/go

    # Useful Aliases
    alias hx helix
    alias lg lazygit
    alias ldo lazydocker

    # Replace 'ls' with 'eza'
    alias ls 'eza -l --color=always --group-directories-first --icons=always'
    alias la 'ls -a'

    # Get fastest mirrors
    alias mirror 'sudo cachyos-rate-mirrors'
    # Cleanup orphaned packages
    alias cleanup 'sudo pacman -Rns (pacman -Qtdq)'

    # Init
    fzf --fish | source
    zoxide init fish | source
    starship init fish | source
    mise activate fish | source
end
