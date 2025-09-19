# dotfiles by d4Rk

😈 d4Rkify your environment 😈

Currently supports:

- Ghostty
- Zsh
- p10k
- tmux
- nvim
- git
- lazygit
- bat

⚠️ Fully support only for macOS and Debian ⚠️

## Install

Chezmoi is used as a dotfiles manager. Here's how to install it.

```bash
# macOS
brew install chezmoi

# Debian
wget https://github.com/twpayne/chezmoi/releases/download/v2.65.0/chezmoi_2.65.0_linux_amd64.deb
sudo dpkg -i chezmoi_2.65.0_linux_amd64.deb
```

## Init

Init chezmoi with this dotfiles repo.

```bash
chezmoi init https://github.com/d4rkd3v1l/dotfiles.git
```

## Update

Update to the latest version. Whenever the requirements script changed, it will be executed again.

```bash
chezmoi update
```

You can also manually run the requirements script, whenever you want.

```bash
chezmoi cd
chezmoi execute-template < run_once_after_install-requirements.sh.tmpl | bash
```
