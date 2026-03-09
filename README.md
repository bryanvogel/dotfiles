# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package   | What it manages                  |
| --------- | -------------------------------- |
| `claude`  | Claude Code agent configurations |
| `ghostty` | Ghostty terminal config          |
| `nvim`    | Neovim config                    |
| `zsh`     | Zsh config and plugins           |

## Dependencies

- [GNU Stow](https://www.gnu.org/software/stow/) — symlink manager
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) — required for Neovim treesitter highlighting (syntax highlighting for classes, variables, etc.)
- [Antidote](https://getantidote.github.io/) — Zsh plugin manager

```sh
brew install stow tree-sitter-cli antidote
```

## Setup

Install the dependencies above, then symlink everything from the repo root:

```sh
cd ~/.dotfiles
stow claude ghostty nvim zsh
```

Or stow a single package:

```sh
stow nvim
```

## After making changes

**Edited a file** — nothing to do. The symlinks point into this repo, so changes are live immediately.

**Added new files or directories** — re-stow the affected package so Stow creates any new symlinks:

```sh
stow -R <package>
```

**Removed files or directories** — unstow first to clean up dead symlinks, then re-stow:

```sh
stow -R <package>
```

`-R` (restow) is equivalent to an unstow followed by a stow, so it handles both additions and removals in one step.

**Added a brand-new package** (e.g. `tmux/`):

1. Create the directory mirroring where the files live relative to `$HOME`:
   ```
   mkdir -p tmux/.config/tmux
   ```
2. Add your config files inside it.
3. Stow it:
   ```sh
   stow tmux
   ```

**Removing a package entirely**:

```sh
stow -D <package>
```

This deletes the symlinks from `$HOME` without touching the files in this repo.

## Re-stow everything at once

```sh
stow -R */
```
