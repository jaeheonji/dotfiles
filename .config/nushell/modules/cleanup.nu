def result-kind-label [kind: string, count: int] {
  match $kind {
    "dir" => { if $count == 1 { "dir" } else { "dirs" } }
    "file" => { if $count == 1 { "file" } else { "files" } }
    "package" => { if $count == 1 { "package" } else { "packages" } }
    _ => { if $count == 1 { $kind } else { $"($kind)s" } }
  }
}

def format-total [results: list] {
  if ($results | is-empty) {
    "0 items"
  } else {
    $results
    | group-by kind
    | transpose kind rows
    | sort-by kind
    | each { |group|
        let count = ($group.rows | length)
        let label = (result-kind-label $group.kind $count)
        $"($count) ($label)"
      }
    | str join ", "
  }
}

def format-targets [root: string, results: list] {
  $results
  | each { |row|
      let rel = if $root == "system" {
        $row.path
      } else {
        $row.path | str replace ($root + "/") ""
      }
      let colored_name = match $row.kind {
        "dir" => { $"(ansi blue)($rel)(ansi reset)" }
        "package" => { $"(ansi green)($rel)(ansi reset)" }
        _ => { $"(ansi yellow)($rel)(ansi reset)" }
      }
      {_kind: $row.kind, _rel: $rel, name: $colored_name}
    }
  | sort-by _kind _rel
  | reject _kind _rel
}

def cleanup-summary-row [label: string, root: string, results: list] {
  {
    Provider: $label
    Root: $root
    Target: (format-targets $root $results)
    Total: (format-total $results)
  }
}

def cleanup-all-summary-row [label: string, root: string, results: list] {
  {
    Provider: $label
    Root: $root
    Total: ($results | length)
    Status: "✓"
  }
}

def print-cleanup-summary [label: string, root: string, results: list] {
  if ($results | is-empty) {
    if $label == "pacman" {
      print $"(ansi green)No orphaned packages to remove.(ansi reset)"
    } else {
      print $"(ansi yellow)($label): Nothing to clean up.(ansi reset)"
    }
  } else {
    print ((cleanup-summary-row $label $root $results) | table -e)
  }
}

def print-cleanup-summaries [summaries: list] {
  let rows = (
    $summaries
    | each { |summary| cleanup-all-summary-row $summary.label $summary.root $summary.results }
  )

  print ($rows | table -e)
}

def complete-cleanup-targets [] {
  [
    {value: "pacman", description: "Remove orphaned pacman packages"}
    {value: "agent", description: "Clean agent caches and session state"}
  ]
}

def complete-cleanup-agent-providers [] {
  [
    {value: "claude", description: "Clean Claude cache, history, sessions, and project state"}
    {value: "codex", description: "Clean Codex cache, logs, sessions, and state files"}
    {value: "all", description: "Run claude and codex cleanup"}
  ]
}

def cleanup-paths [root: string, names: list] {
  $names
  | each { |name|
      let p = ($root | path join $name)
      if ($p | path exists) {
        let kind = ($p | path type)
        rm -rf $p
        {name: $name, path: $p, kind: $kind}
      }
    }
  | compact
}

def cleanup-globs [root: string, patterns: list] {
  $patterns
  | each { |pattern|
      glob ($root | path join $pattern)
      | each { |p|
          if ($p | path exists) {
            let kind = ($p | path type)
            rm -rf $p
            {name: ($p | path basename), path: $p, kind: $kind}
          }
        }
    }
  | flatten
  | compact
}

def cleanup-pacman [] {
  let targets = (pacman -Qtdq | lines)
  if not ($targets | is-empty) {
    sudo pacman -Rns ...$targets
  }

  {
    label: "pacman"
    root: "system"
    results: ($targets | each { |target| {name: $target, path: $target, kind: "package"} })
  }
}

def cleanup-claude [] {
  let claude_dir = if "CLAUDE_CONFIG_DIR" in $env {
    $env.CLAUDE_CONFIG_DIR
  } else {
    $env.HOME | path join ".claude"
  }

  let fixed = [
    "backups" "cache" "file-history" "plans" "projects" "session-env" "sessions" "shell-snapshots"
    "tasks" "history.jsonl"
  ]

  let fixed_results = (cleanup-paths $claude_dir $fixed)

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

  {
    label: "claude"
    root: $claude_dir
    results: ($fixed_results | append $glob_results | append $json_results)
  }
}

def cleanup-codex [] {
  let codex_dir = if "CODEX_HOME" in $env {
    $env.CODEX_HOME
  } else {
    $env.HOME | path join ".config/codex"
  }

  let fixed = [
    "cache" "sessions" "shell_snapshots" "tmp" ".tmp"
    "history.jsonl" "models_cache.json"
  ]

  let patterns = [
    "goals_*.sqlite*" "logs_*.sqlite*" "memories_*.sqlite*" "state_*.sqlite*"
  ]

  let fixed_results = (cleanup-paths $codex_dir $fixed)
  let glob_results = (cleanup-globs $codex_dir $patterns)
  {
    label: "codex"
    root: $codex_dir
    results: ($fixed_results | append $glob_results)
  }
}

def cleanup-all [] {
  print-cleanup-summaries [
    (cleanup-pacman)
    (cleanup-claude)
    (cleanup-codex)
  ]
}

def cleanup-agent-all [] {
  print-cleanup-summaries [
    (cleanup-claude)
    (cleanup-codex)
  ]
}

def print-cleanup-usage [] {
  print $"(ansi default_bold)cleanup(ansi reset) - remove package or agent leftovers"
  print ""
  print $"(ansi default_bold)Usage:(ansi reset)"
  print "  cleanup <command>"
  print "  cleanup --all"
  print ""
  print $"(ansi default_bold)Commands:(ansi reset)"
  print "  pacman        Remove orphaned pacman packages"
  print "  agent         Clean agent caches and session state"
  print ""
  print $"(ansi default_bold)Options:(ansi reset)"
  print "  -a, --all     Run pacman, claude, and codex cleanup"
  print ""
  print $"(ansi default_bold)Examples:(ansi reset)"
  print "  cleanup pacman"
  print "  cleanup agent codex"
  print "  cleanup agent --all"
  print "  cleanup --all"
}

def print-agent-usage [] {
  print $"(ansi default_bold)cleanup agent(ansi reset) - clean agent caches and session state"
  print ""
  print $"(ansi default_bold)Usage:(ansi reset)"
  print "  cleanup agent <provider>"
  print "  cleanup agent --all"
  print ""
  print $"(ansi default_bold)Providers:(ansi reset)"
  print "  claude        Clean Claude cache, history, sessions, and project state"
  print "  codex         Clean Codex cache, logs, sessions, and state files"
  print "  all           Run claude and codex cleanup"
  print ""
  print $"(ansi default_bold)Options:(ansi reset)"
  print "  -a, --all     Run claude and codex cleanup"
  print ""
  print $"(ansi default_bold)Examples:(ansi reset)"
  print "  cleanup agent claude"
  print "  cleanup agent codex"
  print "  cleanup agent --all"
}

export def main [
  target?: string@complete-cleanup-targets
  --all (-a)
] {
  if $all {
    cleanup-all
    return
  }

  match $target {
    "pacman" => {
      let summary = (cleanup-pacman)
      print-cleanup-summary $summary.label $summary.root $summary.results
    }
    null => { print-cleanup-usage }
    _ => { print-cleanup-usage }
  }
}

export def agent [
  provider?: string@complete-cleanup-agent-providers
  --all (-a)
] {
  if $all {
    cleanup-agent-all
    return
  }

  match $provider {
    "claude" => {
      let summary = (cleanup-claude)
      print-cleanup-summary $summary.label $summary.root $summary.results
    }
    "codex" => {
      let summary = (cleanup-codex)
      print-cleanup-summary $summary.label $summary.root $summary.results
    }
    "all" => { cleanup-agent-all }
    null => { print-agent-usage }
    _ => { print-agent-usage }
  }
}
