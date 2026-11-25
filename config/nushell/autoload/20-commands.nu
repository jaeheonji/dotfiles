# Switch to the last directory visited when Yazi exits.
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# Set SHELL to Bash only when launching OpenCode.
def --wrapped opencode [...args: string] {
  with-env { SHELL: "/bin/bash" } {
    ^opencode ...$args
  }
}
