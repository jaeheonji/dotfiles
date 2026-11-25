# env.nu
#
# Installed by:
# version = "0.117.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.PATH ++= [
  ($nu.home-dir | path join ".local/bin")
  ($nu.home-dir | path join ".local/share/nvim/mason/bin")
]

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.CLAUDE_CONFIG_DIR = ($nu.home-dir | path join ".config/claude")
$env.CODEX_HOME = ($nu.home-dir | path join ".config/codex")

$env.NPM_CONFIG_CACHE = ($nu.home-dir| path join ".cache/npm")
$env.GOPATH = ($nu.home-dir | path join ".local/share/go")

$env.BUN_INSTALL_CACHE_DIR = ($nu.home-dir | path join ".cache/bun/install")
$env.BUN_RUNTIME_TRANSPILER_CACHE_PATH = ($nu.home-dir | path join ".cache/bun/transpiler")

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
