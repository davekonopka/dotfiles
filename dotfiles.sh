#!/usr/bin/env bash

# store path to dotfiles folder
export DOT="${DOTFILES_BASE:-$HOME/.dotfiles}"
export CLICOLOR=1
export TERM=xterm-256color
# export DOTFILES_DEBUG="OK"

# This script excludes anything stored under optional/*
# to allow for envrionment specific files to be run manually
# with $DOTFILES_BASE set

function requireEnvVar () {
    varname=$1
    [[ -z "${!varname}" ]] && { echo "${varname} is empty"; return 1; }
    return 0
}

# source environment variables
if [ -f $DOT/.env ]; then
    source $DOT/.env
    [ -n "$DOTFILES_DEBUG" ] && echo "sourced $DOT/.env"
fi
if [ -f ~/.env ]; then
    source ~/.env
    [ -n "$DOTFILES_DEBUG" ] && echo "sourced ~/.env"
fi

# create symlinks
for lnsource in $(find $DOT -name '*.symlink' -not -path "$DOT/optional/*" ); do
    lntarget="${lnsource%.symlink}"
    lntarget="$HOME/${lntarget#$DOT/}"

    if ! ls $lntarget > /dev/null 2>&1; then
        echo "Linking $lntarget ~> $lnsource"
        lntarget_path="$(dirname $lntarget)"
        [ ! -a $lntarget_path ] && mkdir -p $lntarget_path
        ln -s $lnsource $lntarget
        [ -n "$DOTFILES_DEBUG" ] && echo "symlinked $lntarget -> $lnsource"
    fi
done

# source scripts
for script in $(find $DOT -name '*.source' -not -path "$DOT/optional/*" ); do
    source $script
    [ -n "$DOTFILES_DEBUG" ] && echo "sourced $script"
done

# execute scripts
for script in $(find $DOT -name '*.run' -not -path "$DOT/optional/*" ); do
    $script
    [ -n "$DOTFILES_DEBUG" ] && echo "executed $script"
done

# end on a high note
return 0
