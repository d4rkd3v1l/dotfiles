# dotfiles by d4Rk

😈 d4Rkify your environment 😈

Currently supports:

- Aerospace (macOS)
- Sketchybar (macOS)
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

brew install --cask nikitabobko/tap/aerospace
brew tap FelixKratz/formulae
brew install sketchybar
brew install --cask font-sketchybar-app-font
brew install --cask sf-pro
brew install --cask sf-mono
brew install --cask sf-symbols
brew install lua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
brew install borders

# Debian
wget https://github.com/twpayne/chezmoi/releases/download/v2.65.1/chezmoi_2.65.1_linux_amd64.deb
sudo dpkg -i chezmoi_2.65.1_linux_amd64.deb
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
