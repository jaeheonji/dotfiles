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

# oh-my-opencode-slim multiplexer integration
def --wrapped omos [...rest: string] {
    let eq_port = ($rest | where { $in starts-with "--port=" } | first | default "" | str replace "--port=" "")
    let port = if ($eq_port | is-not-empty) {
        $eq_port
    } else {
        let idx = ($rest | enumerate | where item == "--port" | get -o 0.index)
        if $idx != null {
            $rest | get -o ($idx + 1)
        } else {
            null
        }
    }

    if $port != null {
        with-env { OPENCODE_PORT: ($port | into string) } {
            ^opencode ...$rest
        }
    } else {
        let free_port = (port | into string)
        with-env { OPENCODE_PORT: $free_port } {
            ^opencode --port $free_port ...$rest
        }
    }
}
