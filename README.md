# Dotfiles

This repository contains a reproducible macOS and Linux development environment managed with Nix flakes and Home Manager.

The same `rebuild.sh` command works on both platforms:

- macOS uses `nix-darwin` and Home Manager.
- Linux uses standalone Home Manager.
- Linux automatically selects `x86_64` or `aarch64` from the machine architecture.
- iTerm2 is installed and configured only on macOS.
- Linux uses the terminal provided by the SSH client or local desktop.

`flake.lock` is committed intentionally. It pins Nixpkgs, Home Manager, nix-darwin, Oh My Bash, and the other inputs so different machines get the same versions.

## What is managed

### Shared on macOS and Linux

- Neovim, including the same plugins and settings for both `nvim` and `vi`.
- `ripgrep`, `fd`, `fzf`, `jq`, `lazygit`, and `eza`.
- Common shell aliases and the `EDITOR` environment variable.
- The repository-managed Neovim, Claude, Codex, Pi, OpenCode, and Herdr configuration files.

### macOS only

- macOS defaults through `nix-darwin`.
- Homebrew and the `herdr` formula.
- iTerm2 and Claude Code casks.
- iTerm2 dynamic profile and macOS iTerm2 preferences.
- Zsh with Oh My Zsh, the `agnoster` theme, autosuggestions, and syntax highlighting.
- Hack Nerd Font for the agnoster prompt.

### Linux only

- Bash with Oh My Bash, the `agnoster` theme, and the Git plugin.
- A standalone Home Manager profile.

No file or directory icons are configured. File listings use color only.

## Requirements

You need:

- A supported macOS or Linux machine.
- Git.
- Nix with flakes enabled.
- Internet access during the first build so Nix can download inputs and Neovim can install `lazy.nvim` plugins.

The configured username is currently `gnikesh`. The Linux configuration expects the home directory `/home/gnikesh` and the macOS configuration expects `/Users/gnikesh`.

## Fresh macOS installation

### 1. Install Apple command-line tools

Run:

```bash
xcode-select --install
```

If they are already installed, macOS will tell you so.

### 2. Install Nix

This configuration expects the Nix daemon to be managed outside nix-darwin. The simplest match is the [Determinate Nix installer](https://manual.determinate.systems/installation/index.html), which enables flakes by default. On macOS, use the graphical `Determinate.pkg` installer.

After installation, open a new terminal and verify:

```bash
nix --version
nix flake --help
```

If `nix flake` reports that flakes are disabled, enable `nix-command` and `flakes` in your Nix configuration before continuing.

### 3. Clone the repository

Do not clone directly into `~/.dotfiles`. The rebuild script creates `~/.dotfiles` as a symlink to the checkout so the managed files can be edited in place.

```bash
mkdir -p ~/src
git clone git@github.com:gnikesh/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
```

HTTPS also works if SSH keys are not configured:

```bash
git clone https://github.com/gnikesh/dotfiles.git ~/src/dotfiles
```

### 4. Check machine-specific values

Open `flake.nix` and change this line if the macOS username is not `gnikesh`:

```nix
user = "gnikesh";
```

Apple Silicon Macs use the current setting in `configuration.nix`:

```nix
nixpkgs.hostPlatform = "aarch64-darwin";
```

For an Intel Mac, change it to:

```nix
nixpkgs.hostPlatform = "x86_64-darwin";
```

### 5. Bootstrap nix-darwin

`darwin-rebuild` is not available before the first switch. Bootstrap it with the pinned nix-darwin release:

```bash
ln -sfn "$PWD" "$HOME/.dotfiles"
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake "$HOME/.dotfiles#mac"
```

This first switch installs the configured Homebrew packages and casks, creates the Home Manager files, installs the Hack Nerd Font, and configures iTerm2.

After the first successful switch, use `./rebuild.sh` for all future changes.

## Fresh Linux installation

These instructions are intended for a Linux server accessed over SSH. iTerm2 is not installed on the server. Your local terminal remains responsible for rendering fonts and colors.

### 1. Install basic tools

For Debian or Ubuntu, run:

```bash
sudo apt update
sudo apt install -y git curl xz-utils
```

Install the equivalent packages for another distribution. Bash is expected to be available as the login shell.

### 2. Install Nix

The recommended multi-user Nix installation is:

```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```

Log out and back in after installation so the Nix environment is loaded. Verify:

```bash
nix --version
nix flake --help
```

If flakes are not enabled, persist the setting for your user:

```bash
mkdir -p ~/.config/nix
printf '%s\n' 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

The Linux branch of `rebuild.sh` also enables these features for its own run, so the first `./rebuild.sh` can bootstrap a host that does not have this setting yet.

### 3. Clone the repository

Use the same checkout layout as macOS:

```bash
mkdir -p ~/src
git clone git@github.com:gnikesh/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
```

The configured Linux username is `gnikesh`. If the remote account has another username, change `user` in `flake.nix`. If its home directory is not `/home/<username>`, also update the Linux branch of `home.homeDirectory` in `home.nix`.

### 4. Apply the configuration

Run:

```bash
./rebuild.sh
```

The script:

1. Creates or updates `~/.dotfiles` to point to this checkout.
2. Detects Linux and its CPU architecture.
3. Uses `home-manager switch` when the command is already installed.
4. Otherwise, temporarily runs Home Manager through `nix run` and applies the same configuration.

No `sudo` is needed for the Home Manager switch itself.

After it finishes, start a fresh Bash session:

```bash
exec bash
```

## Daily workflow

Edit the files in this repository, then apply changes with:

```bash
cd ~/src/dotfiles
./rebuild.sh
```

The script automatically selects:

```text
macOS             darwinConfigurations.mac
Linux x86_64      homeConfigurations.linux-x86_64
Linux aarch64     homeConfigurations.linux-aarch64
```

The repository uses out-of-store symlinks for authored configuration files. This means changes to files under `home/.config/nvim` and the other managed directories are live from the checkout after a rebuild.

## Private local shell configuration

Machine-specific aliases and secrets should not be committed here.

On macOS, create:

```text
~/.zshrc.local
```

On Linux, create:

```text
~/.bashrc.local
```

For example:

```bash
alias myserver='ssh user@example.com'
```

The appropriate file is sourced after the managed shell configuration. It is safe to leave either file absent.

## Tools installed separately

The following aliases are configured but depend on commands that may come from outside this repository:

- `cc` runs `claude --dangerously-skip-permissions`. On macOS, the Claude Code cask installs this command.
- `co` runs `codex --full-auto`. Install Codex separately if you want to use this alias.
- The `herdr` command is installed through Homebrew on macOS. Linux receives its configuration file, but this repository does not install a Linux Herdr binary.

## Neovim

The Neovim configuration is in `home/.config/nvim` and is shared by `nvim` and `vi`.

Useful defaults include:

- `<leader>e`: toggle the left file tree.
- `<leader>t`: toggle a terminal below the editor.
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: move between windows.
- `<leader>w` followed by `h`, `j`, `k`, or `l`: move between windows through which-key.
- Quitting the final editor window also closes the file tree and terminal.

On the first Neovim launch, `lazy.nvim` is cloned automatically and the plugins listed in `lazy-lock.json` are installed.

## Updating packages and inputs

Update all flake inputs:

```bash
cd ~/src/dotfiles
nix flake update
./rebuild.sh
```

Update only one input:

```bash
nix flake update nixpkgs
nix flake update home-manager
nix flake update oh-my-bash
```

Review the lockfile before applying the update:

```bash
git diff -- flake.lock
```

Most command-line packages are updated through `nixpkgs`. Neovim plugin versions are pinned separately in `home/.config/nvim/lazy-lock.json`.

## Validation

Evaluate all configured targets without building them:

```bash
nix flake check --no-build
```

Build the macOS target without activating it:

```bash
nix build .#darwinConfigurations.mac.system --no-link
```

Build the Linux target on the matching Linux machine:

```bash
nix build .#homeConfigurations.linux-x86_64.activationPackage --no-link
```

Use `linux-aarch64` on an ARM64 Linux machine.

## Troubleshooting

### `darwin-rebuild: command not found`

Run the macOS bootstrap command from the first-install section. After the first successful switch, `darwin-rebuild` is installed and `./rebuild.sh` can be used normally.

### `nix: command not found`

Finish installing Nix, open a new login shell, and verify `nix --version` before running the rebuild script.

### Shell changes are not visible

Start a new shell or run:

```bash
exec zsh   # macOS
exec bash  # Linux
```

### The username or home directory is wrong

Update `user` in `flake.nix`. The current configuration assumes `/Users/<username>` on macOS and `/home/<username>` on Linux.

### Homebrew removes an installed package

macOS Homebrew cleanup is set to `zap`, so Homebrew removes formulae and casks that are not listed in `configuration.nix`. Add anything that should remain managed to that file, then run `./rebuild.sh`.

## Repository layout

```text
flake.nix                         Flake inputs and macOS/Linux outputs
flake.lock                        Pinned versions of all flake inputs
configuration.nix                 macOS system and Homebrew configuration
home.nix                          Shared and platform-specific Home Manager settings
rebuild.sh                        Cross-platform rebuild entry point
home/.config/nvim/                Shared Neovim configuration
home/.config/iterm2/              macOS iTerm2 dynamic profile
home/.config/herdr/               Herdr configuration
```
