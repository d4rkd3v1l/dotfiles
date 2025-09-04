# dotfiles by d4Rk

## Install

```bash
# macOS
brew install chezmoi

# Debian
wget https://github.com/twpayne/chezmoi/releases/download/v2.65.0/chezmoi_2.65.0_linux_amd64.deb
sudo dpkg -i chezmoi_2.65.0_linux_amd64.deb
```

## Setup

```bash
chezmoi init https://github.com/d4rkd3v1l/dotfiles.git

# Run following commands to render the template and then execute the script:
chezmoi cd
chezmoi execute-template < setup.sh.tmpl | bash
```

## Update

```bash
chezmoi update
```
