#!/usr/bin/env bash

# Install Homebrew
if [[ "$(uname)" == 'Darwin' ]]; then
    if ! which brew > /dev/null; then
	echo "Installing homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	echo "Installing bash..."
	brew install bash
	sudo echo /usr/local/bin/bash >> /etc/shells
	chsh -s /usr/local/bin/bash

	echo "Installing some essential apps..."
	brew cask install dropbox
        brew cask install google-chrome
        brew cask install 1password
        brew cask install authy
	brew cask install iterm2
    fi

    # Create ssh config
    if [ ! -f ~/.ssh/config ]; then
        cat >~/.ssh/config <<EOL
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
EOL
    fi
fi

# Create ssh key
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating ssh keys..."
    echo -n "Enter your email address: "
    read email_address
    ssh-keygen -t rsa -b 4096 -C "$email_address"
    eval "$(ssh-agent -s)"
    ssh-add -K ~/.ssh/id_rsa
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

if [[ "$(uname)" == 'Darwin' ]]; then
    if ! grep -i ".dotfiles" ~/.bash_profile > /dev/null ; then
        echo "Add dotfiles sourcing to ~/.bash_profile"
        echo ". ~/.dotfiles/dotfiles.sh" >> ~/.bash_profile
    fi
fi

