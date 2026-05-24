if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings

    function fish_greeting
        echo ""
        bit -char-spacing 1 -direction right -font squaresounds -color "#89b4fa" \
            -align left -gradient "#cba6f7" -scale -1 -word-spacing 1 -line-spacing 0 \
            "welcome!\nmeow"
    end

    # Environments
    set -gx EDITOR helix
    set -gx VISUAL helix

    set -gx CODEX_HOME $HOME/.config/codex
    set -gx GEMINI_CONFIG_DIR $HOME/.config/gemini
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
