# Shell functions. Each returns instead of exiting, so a failure never closes the terminal.

# make a directory and cd into it
take() {
    mkdir -p -- "$1" && cd -- "$1"
}

# go up N directories (default 1)
up() {
    local levels="${1:-1}"
    if [[ ! "$levels" =~ ^[1-9][0-9]*$ ]]; then
        echo "usage: up [positive number]" >&2
        return 1
    fi
    cd "$(printf '../%.0s' {1..$levels})"
}

# yazi: cd into the directory you were in when yazi exits
yy() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    local cwd
    cwd="$(command cat -- "$tmp")"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
    command rm -f -- "$tmp"
}

# git clone, then cd into the new repository
gcl() {
    command git clone "$@" || return
    local target="${@[-1]}"
    [[ -d "$target" ]] || target="${${target:t}%.git}"
    cd -- "$target"
}

# write a .gitignore template, e.g. `gi macos,python > .gitignore`
gi() {
    curl -fsSL "https://www.toptal.com/developers/gitignore/api/$*"
}

# create a GitHub repository from the current directory and push it
create-repo() {
    local name="${1:?usage: create-repo <name> [--public]}"
    local visibility="--private"
    [[ "${2:-}" == "--public" ]] && visibility="--public"
    [[ -d .git ]] || git init
    [[ -f .gitignore ]] || gi macos,python >.gitignore
    git add -A && git commit -m "chore: initial commit"
    gh repo create "$name" "$visibility" --source=. --remote=origin --push
}

# rename a branch locally and on origin
rename-branch() {
    local current_name="${1:?usage: rename-branch <old> <new>}"
    local new_name="${2:?usage: rename-branch <old> <new>}"
    git branch -m "$current_name" "$new_name" &&
        git push origin ":$current_name" "$new_name" &&
        git push origin -u "$new_name"
}

# add everything, prompt for a message, commit and push
git_add_comment_push() {
    local commit_message
    git add .
    read -r "commit_message?Enter commit message: "
    git commit -m "$commit_message" && git push
}

# animated gif from a video; --good for higher quality
gifify() {
    if [[ -z "$1" ]]; then
        echo "usage: gifify <input_movie.mov> [--good]" >&2
        return 1
    fi
    if [[ "$2" == "--good" ]]; then
        ffmpeg -i "$1" -r 10 -vcodec png out-static-%05d.png &&
            magick out-static*.png +dither -layers Optimize -resize 900x900\> GIF:- |
            gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - >"$1.gif"
        command rm -f out-static*.png
    else
        ffmpeg -i "$1" -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 >"$1.gif"
    fi
}

# empty the user trash and the trash on mounted volumes
emptytrash() {
    echo "Emptying trashes..."
    sudo rm -rf /Volumes/*/.Trashes
    command rm -rf ~/.Trash/*(N)
}

# activate the nearest venv or .venv, searching up from the current directory
activate_venv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        for name in .venv venv; do
            if [[ -f "$dir/$name/bin/activate" ]]; then
                source "$dir/$name/bin/activate"
                return 0
            fi
        done
        dir="${dir:h}"
    done
    echo "No Python virtual environment found." >&2
    return 1
}

# Variables a .env file must never override.
typeset -ga DOTENV_PROTECTED_NAMES=(PATH HOME SHELL USER LOGNAME PWD OLDPWD IFS ZDOTDIR FPATH)

# export variables from .env into this shell; --key resolves op:// references.
# Prefer `envrun <command>`: it keeps secrets out of the shell and its children.
setenv() {
    local env_file=".env" use_op=false
    while (( $# )); do
        case "$1" in
        --key) use_op=true ;;
        *)
            echo "Unknown parameter: $1" >&2
            return 1
            ;;
        esac
        shift
    done
    [[ -f "$env_file" ]] || { echo "$env_file not found" >&2; return 1; }

    local line name value
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
        line="${line#export }"
        name="${line%%=*}"
        value="${line#*=}"
        value="${${value#[\"\']}%[\"\']}"
        if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || (( ${DOTENV_PROTECTED_NAMES[(Ie)$name]} )); then
            echo "Skipped unsafe variable name: $name" >&2
            continue
        fi
        if $use_op && [[ "$value" == op://* ]]; then
            (( $+commands[op] )) || { echo "op:// needs the 1Password CLI: brew install 1password-cli" >&2; return 1; }
            value="$(op read "$value")" || return 1
        fi
        export "$name=$value"
    done <"$env_file"
    echo "Environment variables loaded from $env_file"
}

# unset every variable named in .env
unsetenv() {
    local env_file=".env" line name
    [[ -f "$env_file" ]] || { echo "$env_file not found" >&2; return 1; }
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
        line="${line#export }"
        name="${line%%=*}"
        (( ${DOTENV_PROTECTED_NAMES[(Ie)$name]} )) || unset "$name"
    done <"$env_file"
    echo "Environment variables unset from $env_file"
}

# run one command with .env loaded; op:// references resolved by 1Password
envrun() {
    [[ -f .env ]] || { echo ".env not found" >&2; return 1; }
    (( $+commands[op] )) || { echo "envrun needs the 1Password CLI: brew install 1password-cli" >&2; return 1; }
    op run --env-file=.env -- "$@"
}

# remove __pycache__ directories under a directory
clean_pycache() {
    local target_dir="${1:?usage: clean_pycache <directory>}"
    echo "Removing __pycache__ directories under $target_dir..."
    find "$target_dir" -type d -name '__pycache__' -prune -exec rm -rf {} +
}

# delete files matching a pattern, after showing them and asking
# usage: purge "*.csv" [directory]
purge() {
    local pattern="${1:?usage: purge <pattern> [directory]}"
    local target_dir="${2:-.}"
    local -a files=("${(@f)$(find "$target_dir" -name "$pattern" -type f 2>/dev/null)}")
    files=(${files:#})
    if (( ${#files} == 0 )); then
        echo "No files matching '$pattern' found in $target_dir"
        return 0
    fi
    echo "Files to be deleted:"
    printf '  %s\n' "${files[@]}"
    local confirm
    read -r "confirm?Delete these files? [y/N] "
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        command rm -f -- "${files[@]}"
        echo "Deleted files matching '$pattern'"
    else
        echo "Aborted"
    fi
}

# pick a tmux session with sesh + fzf (Alt-s)
sesh-sessions() {
    exec </dev/tty
    exec <&1
    local session
    session="$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')"
    [[ -z "$session" ]] && return
    sesh connect "$session"
}
zle -N sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions
