#!/usr/bin/env bash

# store path to dotfiles folder
export DOT="${DOTFILES_BASE:-$HOME/.dotfiles}"

# create symlinks
for lnsource in $(find $DOT -name '*.symlink' ); do
    lntarget="${lnsource%.symlink}"
    lntarget="$HOME/${lntarget#$DOT/}"

    if ! ls $lntarget > /dev/null 2>&1; then
        echo "Linking $lntarget ~> $lnsource"
        lntarget_path="$(dirname $lntarget)"
        [ ! -a $lntarget_path ] && mkdir -p $lntarget_path
        ln -s $lnsource $lntarget
    fi
done

# source scripts
for script in $(find $DOT -name '*.source' ); do
    source $script
done

# source environment variables
source $DOT/.env
if [ -f ~/.env ]; then
     source ~/.env
fi
