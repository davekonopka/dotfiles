# Dotfiles

![Log lady says "My log does not judge."](https://media.giphy.com/media/l41m6QYDHcEEwjo52/giphy.gif)

## Installation

`curl -s https://raw.githubusercontent.com/davekonopka/dotfiles/master/install.sh | bash`

## Usage

Source `dotfiles.sh` in the shell start script of your choice. This script scans for files with a few extensions in this repo and takes action on them when your shell loads.

### Symlinks

For config files add `.symlink` to the end of any file path in this repo. A symlink will be created in your home directory to the underlying dotfiles file. Files stored under directories will have the same directories in your home directory.

### Source / Execute

Add `.source` to the end of any file in this repo to have it sourced into your shell.

Add `.run` to the end of any file in this repo to have it executed when your shell loads.

### Optional Directories

Anything stored under the `optional/*` directory is ignored. This allows for environment specific files to be included by choice in different environments.

To include an optional set of files, create a directory under `optional/` and add an extra sourcing of `dotfiles.sh` to your shell start script with `DOTFILES_BASE` set.

#### Example Optionals Usage

```
. ~/.dotfiles/dotfiles.sh
DOTFILES_BASE=~/.dotfiles/optional/cool . ~/.dotfiles/dotfiles.sh
```