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

def format-targets [root: any, results: list] {
  $results
  | each { |row|
      let result_root = if "root" in $row { $row.root } else { $root }
      let rel = if $result_root == "system" {
        $row.path
      } else {
        $row.path | str replace ($result_root + "/") ""
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

def cleanup-summary-row [label: string, root: any, results: list] {
  {
    Provider: $label
    Root: $root
    Target: (format-targets $root $results)
    Total: (format-total $results)
  }
}

def cleanup-all-summary-row [label: string, root: any, results: list] {
  {
    Provider: $label
    Root: $root
    Total: ($results | length)
    Status: "✓"
  }
}

def print-cleanup-summary [label: string, root: any, results: list] {
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
    | compact
    | each { |summary| cleanup-all-summary-row $summary.label $summary.root $summary.results }
  )

  if not ($rows | is-empty) { print ($rows | table -e) }
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
    {value: "opencode", description: "Clean OpenCode cache, logs, repositories, snapshots, and state"}
    {value: "omp", description: "Clean Oh My Pi caches, logs, runs, and session state"}
    {value: "all", description: "Run Claude, Codex, OpenCode, and OMP cleanup"}
  ]
}

def cleanup-paths [root: string, names: list] {
  $names
  | each { |name|
      let p = ($root | path join $name)
      if ($p | path exists) {
        let kind = ($p | path type)
        rm -rf $p
        {name: $name, path: $p, kind: $kind, root: $root}
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
            {name: ($p | path basename), path: $p, kind: $kind, root: $root}
          }
        }
    }
  | flatten
  | compact
}

def agent-unavailable [binary: string, root: string] {
  (which $binary | is-empty) or (($root | path type) != "dir")
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

  if (agent-unavailable "claude" $claude_dir) { return null }

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

  if (agent-unavailable "codex" $codex_dir) { return null }

  let fixed = [
    "cache" "sessions" "shell_snapshots" "tmp" ".tmp"
    "history.jsonl" "models_cache.json" "session_index.jsonl"
    "thread-writer-locks"
  ]

  let patterns = [
    "goals_*.sqlite*" "logs_*.sqlite*" "memories_*.sqlite*" "state_*.sqlite*"
    "queue_*.sqlite*" "thread_history_*.sqlite*"
  ]

  let fixed_results = (cleanup-paths $codex_dir $fixed)
  let glob_results = (cleanup-globs $codex_dir $patterns)
  {
    label: "codex"
    root: $codex_dir
    results: ($fixed_results | append $glob_results)
  }
}

def cleanup-opencode [] {
  let cache_home = if "XDG_CACHE_HOME" in $env { $env.XDG_CACHE_HOME } else { $env.HOME | path join ".cache" }
  let data_home = if "XDG_DATA_HOME" in $env { $env.XDG_DATA_HOME } else { $env.HOME | path join ".local/share" }
  let state_home = if "XDG_STATE_HOME" in $env { $env.XDG_STATE_HOME } else { $env.HOME | path join ".local/state" }
  let cache_dir = ($cache_home | path join "opencode")
  let data_dir = ($data_home | path join "opencode")
  let state_dir = ($state_home | path join "opencode")

  if (which opencode | is-empty) or ([$cache_dir $data_dir $state_dir] | all {|dir| ($dir | path type) != "dir"}) {
    return null
  }

  let cache_results = (cleanup-paths $cache_home ["opencode"])
  let data_results = (cleanup-paths $data_dir ["log" "repos" "snapshot" "tool-output"])
  let data_glob_results = (cleanup-globs $data_dir ["storage/oh-my-opencode-slim/*" "opencode.db*"])
  let state_results = (cleanup-paths $state_dir ["locks" "plugin-meta.json" "session.json" "prompt-history.jsonl" "frecency.jsonl"])

  {
    label: "opencode"
    root: {cache: $cache_dir, data: $data_dir, state: $state_dir}
    results: ($cache_results | append $data_results | append $data_glob_results | append $state_results)
  }
}

def cleanup-omp [] {
  let omp_dir = if "PI_CONFIG_DIR" in $env {
    if ($env.PI_CONFIG_DIR | str starts-with "/") {
      $env.PI_CONFIG_DIR
    } else if ($env.PI_CONFIG_DIR | str starts-with "~") {
      $env.PI_CONFIG_DIR | path expand
    } else {
      $env.HOME | path join $env.PI_CONFIG_DIR
    }
  } else {
    $env.HOME | path join ".config/omp"
  }

  if (agent-unavailable "omp" $omp_dir) { return null }

  let omp_data_dir = if "XDG_DATA_HOME" in $env {
    $env.XDG_DATA_HOME | path join "omp"
  } else {
    $env.HOME | path join ".local/share/omp"
  }

  let fixed = [
    "run"
    "cache"
    "logs"
    "agent/cache"
    "agent/terminal-sessions"
  ]

  let data_fixed = [
    "sessions"
  ]

  let data_patterns = [
    "history.db*"
  ]

  let fixed_results = (cleanup-paths $omp_dir $fixed)
  let data_fixed_results = (cleanup-paths $omp_data_dir $data_fixed)
  let data_glob_results = (cleanup-globs $omp_data_dir $data_patterns)

  {
    label: "omp"
    root: {config: $omp_dir, data: $omp_data_dir}
    results: ($fixed_results | append $data_fixed_results | append $data_glob_results)
  }
}

def cleanup-all [] {
  print-cleanup-summaries [
    (cleanup-pacman)
    (cleanup-claude)
    (cleanup-codex)
    (cleanup-opencode)
    (cleanup-omp)
  ]
}

def cleanup-agent-all [] {
  print-cleanup-summaries [
    (cleanup-claude)
    (cleanup-codex)
    (cleanup-opencode)
    (cleanup-omp)
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
  print "  -a, --all     Run pacman, Claude, Codex, OpenCode, and OMP cleanup"
  print ""
  print $"(ansi default_bold)Examples:(ansi reset)"
  print "  cleanup pacman"
  print "  cleanup agent codex"
  print "  cleanup agent opencode"
  print "  cleanup agent omp"
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
  print "  opencode      Clean OpenCode cache, logs, repositories, snapshots, and state"
  print "  omp           Clean Oh My Pi caches, logs, runs, and session state"
  print "  all           Run Claude, Codex, OpenCode, and OMP cleanup"
  print ""
  print $"(ansi default_bold)Options:(ansi reset)"
  print "  -a, --all     Run Claude, Codex, OpenCode, and OMP cleanup"
  print ""
  print $"(ansi default_bold)Examples:(ansi reset)"
  print "  cleanup agent claude"
  print "  cleanup agent codex"
  print "  cleanup agent opencode"
  print "  cleanup agent omp"
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
      if $summary != null { print-cleanup-summary $summary.label $summary.root $summary.results }
    }
    "codex" => {
      let summary = (cleanup-codex)
      if $summary != null { print-cleanup-summary $summary.label $summary.root $summary.results }
    }
    "opencode" => {
      let summary = (cleanup-opencode)
      if $summary != null { print-cleanup-summary $summary.label $summary.root $summary.results }
    }
    "omp" => {
      let summary = (cleanup-omp)
      if $summary != null { print-cleanup-summary $summary.label $summary.root $summary.results }
    }
    "all" => { cleanup-agent-all }
    null => { print-agent-usage }
    _ => { print-agent-usage }
  }
}
