#!/usr/bin/env bash

function print_header() {
    echo -e "\n\033[1;34m$1\033[0m"
}

function print_alias() {
    printf "%-10s \033[1;32m%-40s\033[0m %s\n" "$1" "$2" "$3"
}

function add_aliases() {
    local category="$1"
    shift
    print_header "$category"
    while (("$#")); do
        print_alias "$1" "$2" "$3"
        shift 3
    done
}

function show_git_aliases() {
    add_aliases "Git Aliases" \
        "g" "git" "Use git" \
        "ga" "git add" "Add file contents to the index" \
        "gb" "git branch" "List, create, or delete branches" \
        "gf" "git fetch" "Download objects and refs from another repository" \
        "gg" "git grep" "Print lines matching a pattern" \
        "gl" "git log" "Show commit logs" \
        "gm" "git merge" "Join two or more development histories together" \
        "gr" "git remote" "Manage set of tracked repositories" \
        "gs" "git status" "Show the working tree status" \
        "gw" "git whatchanged" "Show logs with difference each commit introduces" \
        "gmc" "git merge --continue" "Continue the merge process" \
        "gma" "git merge --abort" "Abort the merge process" \
        "gpl" "git pull" "Fetch from and integrate with another repository or a local branch" \
        "gaa" "git add ." "Add current directory contents to the index" \
        "gap" "git add --patch" "Interactively add changes to the index" \
        "gau" "git add --update" "Update the index with the current content found in the working tree" \
        "gbe" "git branch --edit-description" "Edit the description for the branch" \
        "gbd" "git branch -d" "Delete a branch" \
        "gbdd" "git branch -D" "Force delete a branch" \
        "gch" "git checkout" "Switch branches or restore working tree files" \
        "gcb" "git checkout -b" "Create and switch to a new branch" \
        "gbm" "git branch --merged" "List branches that have been merged" \
        "gbnm" "git branch --no-merged" "List branches that have not been merged" \
        "gchp" "git cherry-pick" "Apply the changes introduced by some existing commits" \
        "gcl" "git clone" "Clone a repository into a new directory" \
        "gc" "git commit -am" "Commit changes with message" \
        "gcm" "git commit --amend --message" "Amend the last commit with a new message" \
        "gdt" "git difftool" "Show changes using common diff tools" \
        "gd" "git diff --color" "Show changes between commits, commit and working tree, etc" \
        "gitfix" "git diff --name-only | uniq | xargs code" "Open changed files in VSCode" \
        "ggl" "git grep --line-number" "Print lines matching a pattern with line numbers" \
        "ggg" "git grep --break --heading --line-number" "Print lines matching a pattern with breaks and headings" \
        "glg" "git log --graph" "Show commit logs with a graph" \
        "glo" "git log --oneline" "Show commit logs as a single line per commit" \
        "changelog" "git log --pretty=format:\"%h %ad%x09%an%x09%s\" --date=short" "Generate a changelog" \
        "gp" "git push" "Update remote refs along with associated objects" \
        "gpu" "git push -u origin" "Push the branch and set remote as upstream" \
        "undopush" "git push -f origin HEAD^:master" "Undo the last push" \
        "gre" "git rebase" "Reapply commits on top of another base tip" \
        "gra" "git remote add origin" "Add a new remote" \
        "gst" "git stash" "Stash the changes in a dirty working directory away" \
        "gsa" "git stash apply" "Apply the changes recorded in a stash" \
        "gsp" "git stash pop" "Apply the changes recorded in a stash and remove it from the stash list" \
        "gsd" "git stash drop" "Remove a single stash entry from the list" \
        "gbi" "git browse -- issues" "Open the issues page of the repository in the browser" \
        "gpr" "git pull-request" "Create a pull request"
}

function show_coreutils_aliases() {
    add_aliases "Coreutils Aliases" \
        "tail" "gtail -F" "Follow log rotations" \
        "split" "gsplit" "Split a file into pieces" \
        "csplit" "gcsplit" "Split a file into context-determined pieces" \
        "sum" "gsum" "Checksum and count the blocks in a file" \
        "cksum" "cksum" "Checksum and count the bytes in a file" \
        "md5sum" "gmd5sum" "Compute and check MD5 message digest" \
        "sha1sum" "gsha1sum" "Compute and check SHA1 message digest" \
        "cut" "gcut" "Remove sections from each line of files" \
        "paste" "gpaste" "Merge lines of files" \
        "join" "gjoin" "Join lines of two files on a common field" \
        "cp" "gcp -v" "Copy files and directories" \
        "mv" "gmv -v" "Move files" \
        "rm" "grm -v" "Remove files or directories" \
        "shred" "gshred" "Overwrite a file to hide its contents and optionally delete it" \
        "link" "glink" "Make a hard link between files" \
        "unlink" "gunlink" "Call the unlink function to remove the specified file" \
        "mkdir" "gmkdir -v" "Create directories" \
        "rmdir" "grmdir -v" "Remove empty directories" \
        "readlink" "greadlink" "Print value of a symbolic link or canonical file name" \
        "chmod" "gchmod -v" "Change file modes or Access Control Lists" \
        "chown" "gchown -v" "Change file owner and group" \
        "chgrp" "gchgrp -v" "Change group ownership" \
        "touch" "gtouch" "Change file timestamps" \
        "df" "gdf" "Report file system disk space usage" \
        "stat" "gstat" "Display file or file system status" \
        "sync" "gsync" "Synchronize cached writes to persistent storage" \
        "truncate" "gtruncate" "Shrink or extend the size of a file to the specified size" \
        "echo" "gecho" "Display a line of text" \
        "tee" "gtee" "Read from standard input and write to standard output and files" \
        "awk" "gawk" "Pattern scanning and processing language" \
        "grep" "ggrep --color" "Print lines matching a pattern with color" \
        "ln" "gln" "Make links between files" \
        "ln-sym" "gln -nsf" "Create symbolic links" \
        "find" "gfind" "Search for files in a directory hierarchy" \
        "locate" "glocate" "Find files by name" \
        "updatedb" "gupdatedb" "Update a database for mlocate" \
        "xargs" "gxargs" "Build and execute command lines from standard input" \
        "addr2line" "gaddr2line" "Convert addresses into file names and line numbers" \
        "ar" "gar" "Create, modify, and extract from archives" \
        "c++filt" "gc++filt" "Demangle C++ and Java symbols" \
        "dlltool" "gdlltool" "Create files needed to build and use DLLs" \
        "nlmconv" "gnlmconv" "Convert object code into an NLM" \
        "nm" "gnm" "List symbols from object files" \
        "objcopy" "gobjcopy" "Copy and translate object files" \
        "objdump" "gobjdump" "Display information from object files" \
        "ranlib" "granlib" "Generate index to archive" \
        "readelf" "greadelf" "Display information about ELF files" \
        "size" "gsize" "List section sizes and total size" \
        "strings" "gstrings" "Find printable strings in files" \
        "strip" "gstrip" "Discard symbols from object files" \
        "tar" "gtar" "Manipulate tape archives" \
        "sed" "gsed" "Stream editor for filtering and transforming text" \
        "which" "gwhich" "Locate a command"
}

function show_yarn_aliases() {
    add_aliases "Yarn Aliases" \
        "y" "yarn" "Manage JavaScript projects" \
        "yi" "yarn init" "Create a new Yarn project" \
        "ya" "yarn add" "Add a package" \
        "yad" "yarn add --dev" "Add a dev package" \
        "yga" "yarn global add" "Add a global package" \
        "yr" "yarn run" "Run a defined package script" \
        "ys" "yarn start" "Start a project" \
        "yis" "yarn install && yarn start" "Install dependencies and start the project" \
        "yrm" "yarn remove" "Remove a package" \
        "yup" "yarn upgrade" "Upgrade dependencies" \
        "ycl" "yarn clean" "Clean the project" \
        "ych" "yarn check" "Check for outdated or missing dependencies" \
        "yt" "yarn test" "Run tests" \
        "ycc" "yarn cache clean" "Clean the yarn cache"
}

function show_pnpm_aliases() {
    add_aliases "PNPM Aliases" \
        "pn" "pnpm" "Manage JavaScript projects with pnpm" \
        "pna" "pnpm add" "Add a package with pnpm" \
        "pnr" "pnpm run" "Run a script with pnpm" \
        "pni" "pnpm install" "Install dependencies with pnpm"
}

function show_shortcuts() {
    add_aliases "Shortcuts" \
        "md" "mkdir" "Create directories" \
        "t" "touch" "Create empty files" \
        "x" "exit" "Exit the shell" \
        "c" "clear" "Clear the terminal screen" \
        "o" "open ." "Open the current directory" \
        "vi" "nvim" "Open Neovim" \
        "vim" "nvim" "Open Neovim" \
        "v" "nvim" "Open Neovim" \
        "n" "nvim" "Open Neovim" \
        "x+=" "chmod +x" "Make a file executable" \
        "restart" "sudo reboot" "Reboot the system" \
        "bye" "sudo shutdown -r now" "Restart the system immediately" \
        "get" "curl -O -L" "Download a file using curl" \
        "vi" "vim" "Open Vim" \
        "reload" "source ~/.zshrc" "Reload the shell configuration"
}

function show_special_aliases() {
    add_aliases "Special Aliases" \
        "cat" "bat" "Use bat for displaying file contents" \
        "dev" "cd ~/dev" "Change to development directory" \
        "work" "cd ~/dev/work" "Change to work directory" \
        "desk" "cd ~/desktop" "Change to desktop directory" \
        "docs" "cd ~/documents" "Change to documents directory" \
        "dl" "cd ~/downloads" "Change to downloads directory" \
        "home" "cd ~" "Change to home directory" \
        "dots" "cd ~/dotfiles" "Change to dotfiles directory" \
        "dotfiles" "cd ~/dotfiles" "Change to dotfiles directory" \
        "pip" "uv pip" "Use uv to manage pip" \
        "mergepdf" "/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py" "Merge PDFs using Automator" \
        "spotoff" "sudo mdutil -a -i off" "Turn off Spotlight indexing" \
        "spoton" "sudo mdutil -a -i on" "Turn on Spotlight indexing" \
        "rm_ds" "find . -name '*.DS_Store' -type f -ls -delete" "Remove .DS_Store files" \
        "show" "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder" "Show hidden files" \
        "hide" "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder" "Hide hidden files" \
        "hidedesktop" "defaults write com.apple.finder CreateDesktop -bool false && killall Finder" "Hide desktop items" \
        "showdesktop" "defaults write com.apple.finder CreateDesktop -bool true && killall Finder" "Show desktop items" \
        "chromekill" "ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill" "Kill all Chrome tabs to free memory" \
        "afk" "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend" "Lock screen when going AFK" \
        "stfu" "osascript -e 'set volume output muted true'" "Mute the system volume" \
        "xcodepurge" "rm -rf ~/Library/Developer/Xcode/DerivedData" "Remove cached Xcode build data" \
        "top" "bpytop" "Use bpytop for system monitoring" \
        "du" "ncdu" "Use ncdu for disk usage analysis" \
        "ls" "eza --icons=always" "Use eza for better directory listing" \
        "tree" "eza --tree" "Use eza for better tree listing" \
        "jupyterit" "source $HOME/Codes/lab/.venv/bin/activate && nohup jupyter lab --allow-root > /tmp/lab.log 2>&1 &" "Start Jupyter Lab" \
        "jupyterkill" "kill -9 $(pgrep -f jupyter-lab) && deactivate && rm /tmp/lab.log" "Kill Jupyter Lab" \
        "cmd" "llm_func() { command llm -t cmd \"$@\" | xargs -I {} sh -c \"echo \"execute:\n\t {}\n\"; eval {}\"; }; llm_func" "Productive laziness with llm" \
        "iexit" "tmux kill-session -t $(tmux display-message -p '#S')" "Exit tmux session" \
        "ikill" "tmux kill-server" "Kill tmux server" \
        "iswitch" "tmux choose-session" "Show tmux sessions" \
        "ipop" "tmux display-popup -E \"cd $(tmux display -p -F \"#{pane_current_path}\") && tmux new-session -A -s scratch\"" "Open tmux popup" \
        "f" "thefuck" "Use thefuck for command corrections"
}

function show_functions() {
    add_aliases "Functions" \
        "gi" "generate .gitignore" "Generate .gitignore files" \
        "create-repo" "create a GitHub repo" "Create a new GitHub repository and push initial commit" \
        "take" "mkdir and cd" "Create a directory and change into it" \
        "up" "cd up" "Change directory to a parent directory" \
        "gifify" "convert video to gif" "Create animated gifs from video files" \
        "emptytrash" "empty trashes" "Empty system trashes" \
        "rename-branch" "rename git branch" "Rename a git branch and update it" \
        "git" "smart git clone" "Clone a repository and change into it" \
        "yy" "yazi" "Open yazi with a temporary file for cwd" \
        "activate" "activate Python virtual environment" "Activate virtual environment in current or parent directory" \
        "loadenv" "load .env or -f dotenv file to activate" "Export .env to global PATH" \
        "clean_pycache" "remove all __pycache__ directories" "Clean Python cache files"
}

function show_help() {
    show_git_aliases
    show_coreutils_aliases
    show_yarn_aliases
    show_pnpm_aliases
    show_shortcuts
    show_special_aliases
    show_functions
}

case "$1" in
git)
    show_git_aliases
    ;;
coreutils)
    show_coreutils_aliases
    ;;
yarn)
    show_yarn_aliases
    ;;
pnpm)
    show_pnpm_aliases
    ;;
shortcuts)
    show_shortcuts
    ;;
special)
    show_special_aliases
    ;;
functions)
    show_functions
    ;;
*)
    show_help
    ;;
esac
