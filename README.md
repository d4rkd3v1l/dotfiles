# dotfiles by d4Rk

😈 d4Rkify your environment 😈

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Managed with [chezmoi](https://www.chezmoi.io/).
One command to (re)build your setup on macOS, Debian or Fedora - bathed in [Dracula](https://draculatheme.com/).

## What's inside

- **Shell** — zsh with [zinit](https://github.com/zdharma-continuum/zinit), completions, autosuggestions, syntax highlighting, [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode), [fzf](https://github.com/junegunn/fzf) + [fzf-tab](https://github.com/aloxaf/fzf-tab)
- **Prompt** — [Powerlevel10k](https://github.com/romkatv/powerlevel10k) with a custom Dracula palette
- **Terminal** — [Ghostty](https://ghostty.org/), [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts)
- **tmux** — [tpm](https://github.com/tmux-plugins/tpm) + [dracula/tmux](https://github.com/dracula/tmux)
- **Neovim** — [LazyVim](https://www.lazyvim.org/) - markdown note-taking built around [render-markdown](https://github.com/meanderingprogrammer/render-markdown.nvim)
- **Git** — [delta](https://github.com/dandavison/delta), [lazygit](https://github.com/jesseduffield/lazygit)
- **Helpers** — [bat](https://github.com/sharkdp/bat), [eza](https://github.com/eza-community/eza), [fd](https://github.com/sharkdp/fd), [ripgrep](https://github.com/burntsushi/ripgrep), [fzf](https://github.com/junegunn/fzf), [jq](https://jqlang.org/), [tlrc](https://tldr.sh/tlrc/)
- **Time tracking** — [timewarrior](https://timewarrior.net/) and [tock](https://github.com/kriuchkov/tock)
- WiP/discontinued: Hyprland/waybar/wofi (Linux), Aerospace/sketchybar (macOS)

## Getting started

Install [chezmoi](https://www.chezmoi.io/):

```bash
# macOS
brew install chezmoi

# Debian
wget https://github.com/twpayne/chezmoi/releases/download/v2.72.2/chezmoi_2.72.2_linux_amd64.deb
sudo dpkg -i chezmoi_2.72.2_linux_amd64.deb

# Fedora
sudo dnf install chezmoi
```

Initialize:

```bash
chezmoi init https://github.com/d4rkd3v1l/dotfiles.git
chezmoi apply
```

You'll be prompted for your **name** and **email** (stored locally), and answers 
to the one-time setup: OS packages, zsh as login shell, MesloLGS fonts, tmux plugins. 
May be skipped using `DOTFILES_FRONTEND=noninteractive` e.g. for automation.

## Updating

```bash
# Dotfiles
chezmoi update

# Packages
# macOS
brew upgrade

# Debian
sudo apt upgrade

# Fedora
sudo dnf upgrade
```

## License

MIT © d4Rk — see [LICENSE](LICENSE).
