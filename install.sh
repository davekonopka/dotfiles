#!/usr/bin/env bash

# Install Homebrew
if [[ "$(uname)" == 'Darwin' ]]; then
    if ! which brew > /dev/null; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew cask install dropbox
        brew cask install google-chrome
        brew cask install 1password
        brew cask install authy
    fi
fi

# Create ssh key
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating ssh keys..."
    echo -n "Enter your email address: "
    read email_address
    ssh-keygen -t rsa -b 4096 -C "$email_address"
fi

if [[ ! "$(ssh -T git@github.com 2>&1)" =~ "You've successfully authenticated" ]]; then
    echo
    echo "Public Key:"
    cat ~/.ssh/id_rsa.pub
    echo
    echo "Add key to github. Press enter to continue..."
    read
fi

# Clone dotfiles repo
if [ ! -d ~/.dotfiles ]; then
    git clone ${DOT_REPO:-git@github.com:davekonopka/dotfiles.git} ~/.dotfiles
fi

