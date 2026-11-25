# Apply the Noctalia fzf theme only if the theme file exists.
let theme = ($nu.home-dir | path join ".config/fzf/themes/noctalia.sh")
if ($theme | path exists) {
  $env.FZF_DEFAULT_OPTS = (
    ^bash -c 'source "$1" && printf "%s" "$FZF_DEFAULT_OPTS"' bash $theme
  )
}
