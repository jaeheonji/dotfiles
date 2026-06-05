# config.nu
#
# Installed by:
# version = "0.113.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# My Handy Aliases
alias lg = lazygit

def cleanup [] {
  let targets = (pacman -Qtdq | lines)
  if ($targets | is-empty) {
    print $"(ansi green)No orphaned packages to remove.(ansi reset)"
  } else {
    sudo pacman -Rns ...$targets
  }
}

# Launch yazi and cd into the directory it exits to
def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# Remove Claude session data, cache, and history from CLAUDE_CONFIG_DIR
def claude-clear [] {
  let claude_dir = if "CLAUDE_CONFIG_DIR" in $env {
    $env.CLAUDE_CONFIG_DIR
  } else {
    $env.HOME | path join ".claude"
  }

  let fixed = [
    "backups" "cache" "file-history" "plans" "projects" "session-env" "sessions" "shell-snapshots"
    "history.jsonl"
  ]

  let fixed_results = ($fixed | each { |name|
    let p = ($claude_dir | path join $name)
    if ($p | path exists) {
      let kind = ($p | path type)
      rm -rf $p
      {name: $name, path: $p, kind: $kind}
    }
  } | compact)

  let hud_dir = ($claude_dir | path join "plugins/claude-hud")
  let glob_results = if ($hud_dir | path exists) {
    ls $hud_dir
    | where name =~ "-cache$"
    | each { |entry|
        rm -rf $entry.name
        {name: ($entry.name | path basename), path: $entry.name, kind: $entry.type}
      }
  } else {
    []
  }

  let json_path = ($claude_dir | path join ".claude.json")
  let json_results = if ($json_path | path exists) {
    let data = open $json_path
    if "projects" in $data {
      $data | reject projects | save -f $json_path
      [{name: ".claude.json", path: $json_path, kind: "file"}]
    } else {
      []
    }
  } else {
    []
  }

  let all = ($fixed_results | append $glob_results | append $json_results)

  if ($all | is-empty) {
    print $"(ansi yellow)  Nothing to clean up.(ansi reset)"
  } else {
    let formatted = (
      $all
      | each { |row|
          let rel = ($row.path | str replace ($claude_dir + "/") "")
          let colored_name = if $row.kind == "dir" {
            $"(ansi blue)($rel)(ansi reset)"
          } else {
            $"(ansi yellow)($rel)(ansi reset)"
          }
          {_kind: $row.kind, _rel: $rel, name: $colored_name}
        }
      | sort-by _kind _rel
      | reject _kind _rel
    )

    let total_dirs  = ($all | where kind == "dir"  | length)
    let total_files = ($all | where kind == "file" | length)
    let total_str   = $"($total_dirs) dirs, ($total_files) files"

    print ({CLAUDE_CONFIG_DIR: $claude_dir, Target: $formatted, Total: $total_str} | table -e)
  }
}
