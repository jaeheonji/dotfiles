function aic -d "Clear AI tool caches and session data (claude, codex, gemini)"
    if not type -q gum
        echo "Error: gum is not installed (https://github.com/charmbracelet/gum)" >&2
        return 1
    end

    set -l selected
    if test (count $argv) -eq 0
        set selected claude codex gemini
    else
        for arg in $argv
            switch $arg
                case -h --help
                    _aic_help
                    return 0
                case claude codex gemini
                    set -a selected $arg
                case '*'
                    echo "Error: unknown tool '$arg'" >&2
                    _aic_help >&2
                    return 1
            end
        end
    end

    set -l had_error 0
    for tool in $selected
        switch $tool
            case claude
                _aic_clean_claude; or set had_error 1
            case codex
                _aic_clean_codex; or set had_error 1
            case gemini
                _aic_clean_gemini; or set had_error 1
        end
    end

    test $had_error -eq 0
end

function _aic_help
    echo "Usage: aic [tool...]"
    echo
    echo "Clear local cache/session data for AI CLI tools."
    echo
    echo "Tools: claude, codex, gemini  (default: all three)"
    echo
    echo "Examples:"
    echo "  aic                    # clear all three"
    echo "  aic claude             # clear only claude"
    echo "  aic codex gemini       # clear codex and gemini"
end

function _aic_header
    gum style --bold --foreground 212 "━━━ $argv[1] ━━━"
    gum style --foreground 244 "  $argv[2]"
end

function _aic_table
    gum table -p --separator '|' -c 'Item,Status' --border rounded
end

function _aic_print_table
    if test (count $argv) -eq 0
        echo '(none)|empty' | _aic_table
    else
        printf '%s\n' $argv | _aic_table
    end
end

function _aic_clean_claude
    set -l dir $CLAUDE_CONFIG_DIR
    if test -z "$dir"
        _aic_header claude '(CLAUDE_CONFIG_DIR not set)'
        echo '(none)|skipped' | _aic_table
        return 0
    end
    if not test -d "$dir"
        _aic_header claude "$dir"
        echo '(none)|skipped (no such dir)' | _aic_table
        return 0
    end

    set -l targets backups cache file-history plans tasks projects sessions session-env shell-snapshots history.jsonl
    set -l rows
    set -l had_error 0

    for t in $targets
        set -l p "$dir/$t"
        if test -e "$p"
            if rm -rf "$p" 2>/dev/null
                set -a rows "$t|deleted"
            else
                set -a rows "$t|error"
                set had_error 1
            end
        end
    end

    for r in (command ls -A "$dir" 2>/dev/null | sort)
        set -a rows "$r|remaining"
    end

    _aic_header claude "$dir"
    _aic_print_table $rows

    test $had_error -eq 0
end

function _aic_clean_codex
    set -l dir $CODEX_HOME
    test -z "$dir"; and set dir "$HOME/.config/codex"
    if not test -d "$dir"
        _aic_header codex "$dir"
        echo '(none)|skipped (no such dir)' | _aic_table
        return 0
    end

    set -l targets sessions history.jsonl log shell_snapshots tmp .tmp cache models_cache.json
    set -l rows
    set -l had_error 0

    for t in $targets
        set -l p "$dir/$t"
        if test -e "$p"
            if rm -rf "$p" 2>/dev/null
                set -a rows "$t|deleted"
            else
                set -a rows "$t|error"
                set had_error 1
            end
        end
    end

    for f in (find "$dir" -maxdepth 1 -type f \( -name "*.sqlite" -o -name "*.sqlite-wal" -o -name "*.sqlite-shm" \) 2>/dev/null | sort)
        set -l n (basename "$f")
        if rm -f "$f" 2>/dev/null
            set -a rows "$n|deleted"
        else
            set -a rows "$n|error"
            set had_error 1
        end
    end

    for r in (command ls -A "$dir" 2>/dev/null | sort)
        set -a rows "$r|remaining"
    end

    _aic_header codex "$dir"
    _aic_print_table $rows

    test $had_error -eq 0
end

function _aic_clean_gemini
    set -l root $GEMINI_CONFIG_DIR
    test -z "$root"; and set root "$HOME/.config/gemini"
    set -l dir "$root/.gemini"
    if not test -d "$dir"
        _aic_header gemini "$dir"
        echo '(none)|skipped (no such dir)' | _aic_table
        return 0
    end

    set -l targets history tmp projects.json state.json trustedFolders.json
    set -l rows
    set -l had_error 0

    for t in $targets
        set -l p "$dir/$t"
        if test -e "$p"
            if rm -rf "$p" 2>/dev/null
                set -a rows "$t|deleted"
            else
                set -a rows "$t|error"
                set had_error 1
            end
        end
    end

    for r in (command ls -A "$dir" 2>/dev/null | sort)
        set -a rows "$r|remaining"
    end

    _aic_header gemini "$dir"
    _aic_print_table $rows

    test $had_error -eq 0
end
