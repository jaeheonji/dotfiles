# tests

My scratch space for trying dotfile changes without touching my host. Not a test suite or CI.

- `Containerfile.arch`: Arch Linux.
- `Containerfile.fedora`: Fedora 44.
- Both include Git and mise, copy `config/`, `config-extra/`, and `mise/` to `/opt/dotfiles`, and open Bash there. Rebuild after local changes.

## Running with Podman

From the repo root:

```bash
# Arch Linux
podman build -f tests/Containerfile.arch -t dotfiles-arch .
podman run --rm -it dotfiles-arch

# Fedora
podman build -f tests/Containerfile.fedora -t dotfiles-fedora .
podman run --rm -it dotfiles-fedora
```

## Bootstrapping with mise

Run the matching commands in the container shell. Bootstrap installs packages and tools and applies dotfiles.

```bash
# Arch Linux
mise bootstrap

# Fedora
mise -E fedora bootstrap --only tools
mise -E fedora exec -- mise -E fedora bootstrap
```

On Fedora, install the tools first, then run bootstrap with those tools on `PATH` for the hooks.
