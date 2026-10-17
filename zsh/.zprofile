# Login shells only. /etc/zprofile (path_helper) has just reordered PATH.
dotfiles_path

[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
