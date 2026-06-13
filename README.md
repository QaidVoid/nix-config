# nix-config

Dotfiles and system configuration for an Artix Linux (s6) setup, managed with [just](https://github.com/casey/just) and shell scripts. No frameworks, no agents, no bloat.

## Structure

```
.
├── justfile              # task runner and deployment logic
├── scripts/
│   └── aur               # AUR installer with PKGBUILD security checks
├── home/
│   ├── config/           # ~/.config/* (file-level, e.g. fish/config.fish)
│   └── s6/sv/            # user-level s6 services (pipewire, wireplumber, ...)
├── etc/                  # /etc/* (fstab, hostname, ...)
└── pkg/                  # package lists
    ├── base              # kernel, boot, networking, disk
    ├── desktop           # gui, audio, cli, apps
    └── aur               # AUR packages
```

## Quick start

```bash
just add ~/.config/fish/config.fish   # start tracking a file
just managed                           # see what's tracked
just dry                               # preview what would happen
just apply                             # deploy everything
just status                            # check for drift
```

## Targets

| Target | Description |
|---|---|
| `just apply` | Deploy everything in order |
| `just add <path>` | Start tracking a deployed file |
| `just forget <path>` | Stop tracking (removes from repo, not target) |
| `just managed` | List all tracked files |
| `just user` | Deploy configs to `~/.config/` and `~/` |
| `just system` | Deploy configs to `/etc/` (needs sudo) |
| `just user-services` | Deploy and start user s6 services |
| `just packages` | Install pacman packages from `pkg/` |
| `just aur` | Install AUR packages (with security review) |
| `just services` | Enable and start s6 system services |
| `just pkg-update` | `pacman -Syu` |
| `just aur-update` | Update AUR packages with PKGBUILD diff check |
| `just status` | Show which deployed files have drifted |
| `just diff` | Show actual diffs for drifted files |
| `just pull` | Pull deployed changes back into repo |
| `just dry` | Dry run of `just apply` |
| `just force <target>` | Force overwrite for a single target |
| `just force-all` | Force overwrite everything |
| `just yes <target>` | Auto-confirm prompts for a target |

## Auto-discovery

No manifests to maintain. The justfile auto-discovers files from the directory structure:

| Repo location | Deploys to |
|---|---|
| `home/config/**` | `~/.config/**` |
| `home/**` (excl. `config/`, `s6/`) | `~/**` |
| `etc/**` (excl. `s6/`) | `/etc/**` |
| `home/s6/sv/*` (excl. `default`) | `~/.local/share/s6/sv/*` |
| `pkg/*` (excl. `aur`) | pacman package lists |
| `pkg/aur*` | AUR package lists |

Drop a file in the right place, it's tracked. No variable edits needed.

## File-level tracking

Files are tracked individually, not as whole directories. This means:

```bash
just add ~/.config/fish/config.fish
# tracks ONLY config.fish
# ~/.config/fish/functions/, conf.d/, fish_variables are left untouched
```

This lets you selectively manage specific files in directories that also contain machine-generated or private content.

## Drift tracking

Since files are copied (not symlinked), deployed versions can drift from the repo:

```bash
just status      # list files that have drifted
just diff        # show the actual differences
just pull        # copy deployed changes back into the repo
just force user  # overwrite deployed files with repo versions
```

## AUR security

The `scripts/aur` script provides:

- **Dependency resolution**: recursively resolves AUR dependencies, skipping installed and official repo packages
- **PKGBUILD review on first install**: shows the full PKGBUILD and requires `[y/N]` approval
- **PKGBUILD diff on updates**: compares cached PKGBUILD with the new one; if only `pkgver`/`pkgrel`/checksums changed, auto-approves. Any other changes require explicit approval.
- **VCS package handling**: `-git` packages always rebuild since their version is computed at build time

## s6 user services

User services (pipewire, wireplumber, etc.) run under a user-managed s6-rc instance -- no system services or root required:

1. `just user-services` deploys service files to `~/.local/share/s6/sv/` and compiles the user database
2. `just user` deploys the fish autostart snippet (`~/.config/fish/conf.d/s6.fish`)
3. On login, fish backgrounds `start-session`, which starts `s6-svscan`, runs `s6-rc-init`, and brings up the `default` bundle

The session is fully user-owned: `s6-svscan` runs as your user, services start after login (not boot), and stop when you log out.

Manage user services:

```bash
s6-rc -l $XDG_RUNTIME_DIR/s6-rc -u change pipewire      # start
s6-rc -l $XDG_RUNTIME_DIR/s6-rc -d change pipewire      # stop
s6-rc -l $XDG_RUNTIME_DIR/s6-rc -up change default      # start all
s6-rc -l $XDG_RUNTIME_DIR/s6-rc -d change default       # stop all
```
