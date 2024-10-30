#!/bin/sh
# Prompt to continue in command chain (e.g.  confirm "You really want to revert everything this?" && git reset --hard)

read -r -p "$(echo \\e[33m\\e[1m${1:-Are you sure?}\\e[0m) [y/N] " response
#read -r -p "\e[33m${1:-Are you sure? [y/N]}\e[0m" response
case $response in
[yY][eE][sS]|[yY])
        true
        ;;
*)
        false
        ;;
esac
