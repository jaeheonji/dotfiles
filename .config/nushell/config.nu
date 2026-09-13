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

use modules/cleanup.nu

# My Handy Aliases
alias lg = lazygit

# Integration for oh-my-opencode-slim 
def --wrapped omos [...args] {
	let inline_port = ($args | where {|arg| $arg | str starts-with "--port=" } | first | default null)
	let given_port = if $inline_port != null {
		$inline_port | str replace "--port=" ""
	} else {
		let flag = ($args | enumerate | where item == "--port" | first | get -o index)
		if $flag != null { $args | get -o ($flag + 1) }
	}

	let opencode_port = if ($given_port | is-empty) { port } else { $given_port }
	with-env { OPENCODE_PORT: $opencode_port } {
		if ($given_port | is-empty) {
			^opencode --port $opencode_port ...$args
		} else {
			^opencode ...$args
		}
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
