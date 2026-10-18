#!/bin/bash
# Stow packages: top-level directories linked into $HOME.
# Single list used by install.sh, scripts/doctor.sh and CI.
# shellcheck disable=SC2034 # used by the scripts that source this file
readonly STOW_PACKAGES=(aerospace atuin ghostty git mise nvim sesh starship tmux uv yazi zsh)
