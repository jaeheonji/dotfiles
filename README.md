# Jaeheon's dotfiles

My personal dotfiles for **Linux, WSL, and macOS**, managed with [mise-en-place](https://mise.jdx.dev/). The application configs in [`config/`](config/) and [`config-extra/`](config-extra/) are plain files you can read, copy, or adapt on their own. The [`mise/`](mise/) directory defines what gets installed and which files get copied or symlinked into place.

## Why mise?

I switch between macOS, WSL, and Linux distributions such as Arch, Fedora, and Ubuntu. I chose **mise** because it lets me manage **developer tools, environment variables, tasks, and machine setup** with the same CLI. Its bootstrap configuration lets me share a base setup and layer on settings for a particular machine or distribution. [Mise bootstrap documentation](https://mise.jdx.dev/bootstrap.html)

Getting familiar with mise's bootstrap feature and the concepts behind it can take some time. I hope this repository serves as a practical example and a starting point for anyone interested in trying it out.

## Installation

[Install mise](https://mise.jdx.dev/installing-mise.html), then run the command below. On **Fedora**, follow the [two-step setup](#set-up-on-fedora).

```bash
mise bootstrap --from https://github.com/jaeheonji/dotfiles.git --config-dir mise
```

**`--from`** checks out the repository from GitHub. **`--config-dir mise`** links its `mise/` directory as your global mise config, usually `~/.config/mise`. That destination must be missing, empty, or already linked to this checkout. [Bootstrapping from a repository](https://mise.jdx.dev/bootstrap/from-repository.html#global-config-elsewhere)

### install with profiles

Use **`-E`** to enable extra profiles alongside the base setup. For example, this enables the Kitty terminal configuration and the font packages available for your platform.

```bash
mise -E kitty,fonts bootstrap --from https://github.com/jaeheonji/dotfiles.git --config-dir mise
```

### set up on Fedora

Some tools in this setup are unavailable in Fedora's official package repositories. On Arch, I can use community sources such as the **AUR** through mise. For Fedora, I use mise's **tool backends** to install **Starship**, **Yazi**, and **ouch** without adding a third-party DNF repository.

Install the tools from the `fedora` profile first, then run the full bootstrap through **`mise exec`** so the dotfile hooks can find them on `PATH`.

```bash
mise -E fedora bootstrap --from https://github.com/jaeheonji/dotfiles.git --config-dir mise --only tools
mise -E fedora exec -- mise -E fedora bootstrap
```

## Layout

```text
.
├── config/                 # Everyday app configs
│   ├── nushell/            # Shell settings and autoload scripts
│   ├── nvim/               # Neovim settings and plugins
│   ├── yazi/               # File manager settings and theme
│   └── ...
├── config-extra/           # Optional app and desktop configs
│   ├── compositor/         # Umbriel and Qt engine settings
│   ├── desktop/            # Noctalia settings and theme integrations
│   └── terminal/           # Kitty terminal settings
├── mise/                   # Bootstrap and deployment configuration
│   ├── conf.d/             # Base packages and app configs, grouped by category
│   ├── config.toml         # Base bootstrap settings
│   ├── config.*.toml       # Profile-specific settings
│   └── miserc.toml         # Named profile sets
└── tests/                  # Containers for trying bootstrap changes
    ├── Containerfile.arch
    └── Containerfile.fedora
```

## Available Profiles

Select one or more profiles with `-E`, for example `-E kitty,fonts`.

The base setup loads the numbered fragments in `mise/conf.d/`. Shared CLI
packages live in `00-packages.toml`. The other fragments keep each category's
packages, dotfiles, and hooks together. Optional setups live in profile files.

| Profile | What it adds |
| --- | --- |
| `fedora` | Installs Starship, Yazi, and ouch through mise's tool backends. See the [Fedora setup](#set-up-on-fedora) for the required install order. |
| `fonts` | Installs Pretendard, Geist, and Maple Mono NF on Arch Linux, or Maple Mono NF on macOS. |
| `kitty` | Installs Kitty on Arch Linux, Fedora, and macOS and deploys its terminal configuration. |
| `noctalia` | Installs Noctalia on Arch Linux and Fedora and applies its theme to LazyVim and fzf in Nushell. |
| `umbriel` | Installs Umbriel from Chaotic-AUR and Qt Engine from the AUR, then deploys their settings. |

Profile sets are defined in [`mise/miserc.toml`](mise/miserc.toml). For example, `-E umbriel-desktop` enables `fonts`, `kitty`, `noctalia`, and `umbriel` together.

## License

[MIT](LICENSE)
