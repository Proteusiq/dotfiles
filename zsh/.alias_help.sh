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
        "setenv" "load .env or -f dotenv file to activate" "Export .env to global PATH" \
        "unsetenv" "unload .env or -f dotenv file to activate" "Export .env to global PATH" \
        "clean_pycache" "remove all __pycache__ directories" "Clean Python cache files"
}

function describe_alias() {
    local alias_name="$1"
    case "$alias_name" in
        g) print_alias "g" "git" "Use git" ;;
        ga) print_alias "ga" "git add" "Add file contents to the index" ;;
        gb) print_alias "gb" "git branch" "List, create, or delete branches" ;;
        gf) print_alias "gf" "git fetch" "Download objects and refs from another repository" ;;
        gg) print_alias "gg" "git grep" "Print lines matching a pattern" ;;
        gl) print_alias "gl" "git log" "Show commit logs" ;;
        gm) print_alias "gm" "git merge" "Join two or more development histories together" ;;
        gr) print_alias "gr" "git remote" "Manage set of tracked repositories" ;;
        gs) print_alias "gs" "git status" "Show the working tree status" ;;
        gw) print_alias "gw" "git whatchanged" "Show logs with difference each commit introduces" ;;
        gmc) print_alias "gmc" "git merge --continue" "Continue the merge process" ;;
        gma) print_alias "gma" "git merge --abort" "Abort the merge process" ;;
        gpl) print_alias "gpl" "git pull" "Fetch from and integrate with another repository or a local branch" ;;
        gaa) print_alias "gaa" "git add ." "Add current directory contents to the index" ;;
        gap) print_alias "gap" "git add --patch" "Interactively add changes to the index" ;;
        gau) print_alias "gau" "git add --update" "Update the index with the current content found in the working tree" ;;
        gbe) print_alias "gbe" "git branch --edit-description" "Edit the description for the branch" ;;
        gbd) print_alias "gbd" "git branch -d" "Delete a branch" ;;
        gbdd) print_alias "gbdd" "git branch -D" "Force delete a branch" ;;
        gch) print_alias "gch" "git checkout" "Switch branches or restore working tree files" ;;
        gcb) print_alias "gcb" "git checkout -b" "Create and switch to a new branch" ;;
        gbm) print_alias "gbm" "git branch --merged" "List branches that have been merged" ;;
        gbnm) print_alias "gbnm" "git branch --no-merged" "List branches that have not been merged" ;;
        gchp) print_alias "gchp" "git cherry-pick" "Apply the changes introduced by some existing commits" ;;
        gcl) print_alias "gcl" "git clone" "Clone a repository into a new directory" ;;
        gc) print_alias "gc" "git commit -am" "Commit changes with message" ;;
        gcm) print_alias "gcm" "git commit --amend --message" "Amend the last commit with a new message" ;;
        gdt) print_alias "gdt" "git difftool" "Show changes using common diff tools" ;;
        gd) print_alias "gd" "git diff --color" "Show changes between commits, commit and working tree, etc" ;;
        gitfix) print_alias "gitfix" "git diff --name-only | uniq | xargs code" "Open changed files in VSCode" ;;
        ggl) print_alias "ggl" "git grep --line-number" "Print lines matching a pattern with line numbers" ;;
        ggg) print_alias "ggg" "git grep --break --heading --line-number" "Print lines matching a pattern with breaks and headings" ;;
        glg) print_alias "glg" "git log --graph" "Show commit logs with a graph" ;;
        glo) print_alias "glo" "git log --oneline" "Show commit logs as a single line per commit" ;;
        changelog) print_alias "changelog" "git log --pretty=format:\"%h %ad%x09%an%x09%s\" --date=short" "Generate a changelog" ;;
        gp) print_alias "gp" "git push" "Update remote refs along with associated objects" ;;
        gpu) print_alias "gpu" "git push -u origin" "Push the branch and set remote as upstream" ;;
        undopush) print_alias "undopush" "git push -f origin HEAD^:master" "Undo the last push" ;;
        gre) print_alias "gre" "git rebase" "Reapply commits on top of another base tip" ;;
        gra) print_alias "gra" "git remote add origin" "Add a new remote" ;;
        gst) print_alias "gst" "git stash" "Stash the changes in a dirty working directory away" ;;
        gsa) print_alias "gsa" "git stash apply" "Apply the changes recorded in a stash" ;;
        gsp) print_alias "gsp" "git stash pop" "Apply the changes recorded in a stash and remove it from the stash list" ;;
        gsd) print_alias "gsd" "git stash drop" "Remove a single stash entry from the list" ;;
        gbi) print_alias "gbi" "git browse -- issues" "Open the issues page of the repository in the browser" ;;
        gpr) print_alias "gpr" "git pull-request" "Create a pull request" ;;
        tail) print_alias "tail" "gtail -F" "Follow log rotations" ;;
        split) print_alias "split" "gsplit" "Split a file into pieces" ;;
        csplit) print_alias "csplit" "gcsplit" "Split a file into context-determined pieces" ;;
        sum) print_alias "sum" "gsum" "Checksum and count the blocks in a file" ;;
        cksum) print_alias "cksum" "cksum" "Checksum and count the bytes in a file" ;;
        md5sum) print_alias "md5sum" "gmd5sum" "Compute and check MD5 message digest" ;;
        sha1sum) print_alias "sha1sum" "gsha1sum" "Compute and check SHA1 message digest" ;;
        cut) print_alias "cut" "gcut" "Remove sections from each line of files" ;;
        paste) print_alias "paste" "gpaste" "Merge lines of files" ;;
        join) print_alias "join" "gjoin" "Join lines of two files on a common field" ;;
        cp) print_alias "cp" "gcp -v" "Copy files and directories" ;;
        mv) print_alias "mv" "gmv -v" "Move files" ;;
        rm) print_alias "rm" "grm -v" "Remove files or directories" ;;
        shred) print_alias "shred" "gshred" "Overwrite a file to hide its contents and optionally delete it" ;;
        link) print_alias "link" "glink" "Make a hard link between files" ;;
        unlink) print_alias "unlink" "gunlink" "Call the unlink function to remove the specified file" ;;
        mkdir) print_alias "mkdir" "gmkdir -v" "Create directories" ;;
        rmdir) print_alias "rmdir" "grmdir -v" "Remove empty directories" ;;
        readlink) print_alias "readlink" "greadlink" "Print value of a symbolic link or canonical file name" ;;
        chmod) print_alias "chmod" "gchmod -v" "Change file modes or Access Control Lists" ;;
        chown) print_alias "chown" "gchown -v" "Change file owner and group" ;;
        chgrp) print_alias "chgrp" "gchgrp -v" "Change group ownership" ;;
        touch) print_alias "touch" "gtouch" "Change file timestamps" ;;
        df) print_alias "df" "gdf" "Report file system disk space usage" ;;
        stat) print_alias "stat" "gstat" "Display file or file system status" ;;
        sync) print_alias "sync" "gsync" "Synchronize cached writes to persistent storage" ;;
        truncate) print_alias "truncate" "gtruncate" "Shrink or extend the size of a file to the specified size" ;;
        echo) print_alias "echo" "gecho" "Display a line of text" ;;
        tee) print_alias "tee" "gtee" "Read from standard input and write to standard output and files" ;;
        awk) print_alias "awk" "gawk" "Pattern scanning and processing language" ;;
        grep) print_alias "grep" "ggrep --color" "Print lines matching a pattern with color" ;;
        ln) print_alias "ln" "gln" "Make links between files" ;;
        ln-sym) print_alias "ln-sym" "gln -nsf" "Create symbolic links" ;;
        find) print_alias "find" "gfind" "Search for files in a directory hierarchy" ;;
        locate) print_alias "locate" "glocate" "Find files by name" ;;
        updatedb) print_alias "updatedb" "gupdatedb" "Update a database for mlocate" ;;
        xargs) print_alias "xargs" "gxargs" "Build and execute command lines from standard input" ;;
        addr2line) print_alias "addr2line" "gaddr2line" "Convert addresses into file names and line numbers" ;;
        ar) print_alias "ar" "gar" "Create, modify, and extract from archives" ;;
        c++filt) print_alias "c++filt" "gc++filt" "Demangle C++ and Java symbols" ;;
        dlltool) print_alias "dlltool" "gdlltool" "Create files needed to build and use DLLs" ;;
        nlmconv) print_alias "nlmconv" "gnlmconv" "Convert object code into an NLM" ;;
        nm) print_alias "nm" "gnm" "List symbols from object files" ;;
        objcopy) print_alias "objcopy" "gobjcopy" "Copy and translate object files" ;;
        objdump) print_alias "objdump" "gobjdump" "Display information from object files" ;;
        ranlib) print_alias "ranlib" "granlib" "Generate index to archive" ;;
        readelf) print_alias "readelf" "greadelf" "Display information about ELF files" ;;
        size) print_alias "size" "gsize" "List section sizes and total size" ;;
        strings) print_alias "strings" "gstrings" "Find printable strings in files" ;;
        strip) print_alias "strip" "gstrip" "Discard symbols from object files" ;;
        tar) print_alias "tar" "gtar" "Manipulate tape archives" ;;
        sed) print_alias "sed" "gsed" "Stream editor for filtering and transforming text" ;;
        which) print_alias "which" "gwhich" "Locate a command" ;;
        y) print_alias "y" "yarn" "Manage JavaScript projects" ;;
        yi) print_alias "yi" "yarn init" "Create a new Yarn project" ;;
        ya) print_alias "ya" "yarn add" "Add a package" ;;
        yad) print_alias "yad" "yarn add --dev" "Add a dev package" ;;
        yga) print_alias "yga" "yarn global add" "Add a global package" ;;
        yr) print_alias "yr" "yarn run" "Run a defined package script" ;;
        ys) print_alias "ys" "yarn start" "Start a project" ;;
        yis) print_alias "yis" "yarn install && yarn start" "Install dependencies and start the project" ;;
        yrm) print_alias "yrm" "yarn remove" "Remove a package" ;;
        yup) print_alias "yup" "yarn upgrade" "Upgrade dependencies" ;;
        ycl) print_alias "ycl" "yarn clean" "Clean the project" ;;
        ych) print_alias "ych" "yarn check" "Check for outdated or missing dependencies" ;;
        yt) print_alias "yt" "yarn test" "Run tests" ;;
        ycc) print_alias "ycc" "yarn cache clean" "Clean the yarn cache" ;;
        pn) print_alias "pn" "pnpm" "Manage JavaScript projects with pnpm" ;;
        pna) print_alias "pna" "pnpm add" "Add a package with pnpm" ;;
        pnr) print_alias "pnr" "pnpm run" "Run a script with pnpm" ;;
        pni) print_alias "pni" "pnpm install" "Install dependencies with pnpm" ;;
        md) print_alias "md" "mkdir" "Create directories" ;;
        t) print_alias "t" "touch" "Create empty files" ;;
        x) print_alias "x" "exit" "Exit the shell" ;;
        c) print_alias "c" "clear" "Clear the terminal screen" ;;
        o) print_alias "o" "open ." "Open the current directory" ;;
        vi) print_alias "vi" "nvim" "Open Neovim" ;;
        vim) print_alias "vim" "nvim" "Open Neovim" ;;
        v) print_alias "v" "nvim" "Open Neovim" ;;
        n) print_alias "n" "nvim" "Open Neovim" ;;
        x+=) print_alias "x+=" "chmod +x" "Make a file executable" ;;
        restart) print_alias "restart" "sudo reboot" "Reboot the system" ;;
        bye) print_alias "bye" "sudo shutdown -r now" "Restart the system immediately" ;;
        get) print_alias "get" "curl -O -L" "Download a file using curl" ;;
        reload) print_alias "reload" "source ~/.zshrc" "Reload the shell configuration" ;;
        cat) print_alias "cat" "bat" "Use bat for displaying file contents" ;;
        dev) print_alias "dev" "cd ~/dev" "Change to development directory" ;;
        work) print_alias "work" "cd ~/dev/work" "Change to work directory" ;;
        desk) print_alias "desk" "cd ~/desktop" "Change to desktop directory" ;;
        docs) print_alias "docs" "cd ~/documents" "Change to documents directory" ;;
        dl) print_alias "dl" "cd ~/downloads" "Change to downloads directory" ;;
        home) print_alias "home" "cd ~" "Change to home directory" ;;
        dots) print_alias "dots" "cd ~/dotfiles" "Change to dotfiles directory" ;;
        dotfiles) print_alias "dotfiles" "cd ~/dotfiles" "Change to dotfiles directory" ;;
        pip) print_alias "pip" "uv pip" "Use uv to manage pip" ;;
        mergepdf) print_alias "mergepdf" "/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py" "Merge PDFs using Automator" ;;
        spotoff) print_alias "spotoff" "sudo mdutil -a -i off" "Turn off Spotlight indexing" ;;
        spoton) print_alias "spoton" "sudo mdutil -a -i on" "Turn on Spotlight indexing" ;;
        rm_ds) print_alias "rm_ds" "find . -name '*.DS_Store' -type f -ls -delete" "Remove .DS_Store files" ;;
        show) print_alias "show" "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder" "Show hidden files" ;;
        hide) print_alias "hide" "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder" "Hide hidden files" ;;
        hidedesktop) print_alias "hidedesktop" "defaults write com.apple.finder CreateDesktop -bool false && killall Finder" "Hide desktop items" ;;
        showdesktop) print_alias "showdesktop" "defaults write com.apple.finder CreateDesktop -bool true && killall Finder" "Show desktop items" ;;
        chromekill) print_alias "chromekill" "ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill" "Kill all Chrome tabs to free memory" ;;
        afk) print_alias "afk" "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend" "Lock screen when going AFK" ;;
        stfu) print_alias "stfu" "osascript -e 'set volume output muted true'" "Mute the system volume" ;;
        xcodepurge) print_alias "xcodepurge" "rm -rf ~/Library/Developer/Xcode/DerivedData" "Remove cached Xcode build data" ;;
        gi) print_alias "gi" "generate .gitignore" "Generate .gitignore files" ;;
        create-repo) print_alias "create-repo" "create a GitHub repo" "Create a new GitHub repository and push initial commit" ;;
        take) print_alias "take" "mkdir and cd" "Create a directory and change into it" ;;
        up) print_alias "up" "cd up" "Change directory to a parent directory" ;;
        gifify) print_alias "gifify" "convert video to gif" "Create animated gifs from video files" ;;
        emptytrash) print_alias "emptytrash" "empty trashes" "Empty system trashes" ;;
        rename-branch) print_alias "rename-branch" "rename git branch" "Rename a git branch and update it" ;;
        git) print_alias "git" "smart git clone" "Clone a repository and change into it" ;;
        yy) print_alias "yy" "yazi" "Open yazi with a temporary file for cwd" ;;
        activate) print_alias "activate" "activate Python virtual environment" "Activate virtual environment in current or parent directory" ;;
        setenv) print_alias "setenv" "load .env or -f dotenv file to activate" "Export .env to global PATH" ;;
        unsetenv) print_alias "unsetenv" "unload .env or -f dotenv file to activate" "Export .env to global PATH" ;;
        clean_pycache) print_alias "clean_pycache" "remove all __pycache__ directories" "Clean Python cache files" ;;
        jupyterit) print_alias "jupyterit" "source $HOME/Codes/lab/.venv/bin/activate && nohup jupyter lab --allow-root > /tmp/lab.log 2>&1 &" "Start Jupyter Lab" ;;
        jupyterkill) print_alias "jupyterkill" "kill -9 $(pgrep -f jupyter-lab) && deactivate && rm /tmp/lab.log" "Kill Jupyter Lab" ;;
        cmd) print_alias "cmd" "llm_func() { command llm -t cmd \"$@\" | xargs -I {} sh -c \"echo \"execute:\n\t {}\n\"; eval {}\"; }; llm_func" "Productive laziness with llm" ;;
        iexit) print_alias "iexit" "tmux kill-session -t $(tmux display-message -p '#S')" "Exit tmux session" ;;
        ikill) print_alias "ikill" "tmux kill-server" "Kill tmux server" ;;
        iswitch) print_alias "iswitch" "tmux choose-session" "Show tmux sessions" ;;
        ipop) print_alias "ipop" "tmux display-popup -E \"cd $(tmux display -p -F \"#{pane_current_path}\") && tmux new-session -A -s scratch\"" "Open tmux popup" ;;
        f) print_alias "f" "thefuck" "Use thefuck for command corrections" ;;
        top) print_alias "top" "bpytop" "Use bpytop for system monitoring" ;;
        du) print_alias "du" "ncdu" "Use ncdu for disk usage analysis" ;;
        ls) print_alias "ls" "eza --icons=always" "Use eza for better directory listing" ;;
        tree) print_alias "tree" "eza --tree" "Use eza for better tree listing" ;;
        *) echo "Alias '$alias_name' not found." ;;
        *) echo "Alias '$alias_name' not found." ;;
    esac
}

function show_help() {
    echo -e "\033[1;36mUsage:\033[0m alias [--help category]"
    echo -e "\033[1;33mCategories:\033[0m"
    echo -e "  \033[1;32mgit\033[0m        Show Git aliases"
    echo -e "  \033[1;32mcoreutils\033[0m  Show Coreutils aliases"
    echo -e "  \033[1;32myarn\033[0m       Show Yarn aliases"
    echo -e "  \033[1;32mpnpm\033[0m       Show PNPM aliases"
    echo -e "  \033[1;32mshortcuts\033[0m  Show Shortcuts"
    echo -e "  \033[1;32mspecial\033[0m    Show Special aliases"
    echo -e "  \033[1;32mfunctions\033[0m  Show Functions"
    echo -e "\033[1;33mOptions:\033[0m"
    echo -e "  \033[1;32m--describe alias_name\033[0m  Describe a specific alias"
}

if [[ "$1" == "--describe" ]]; then
    describe_alias "$2"
else
    case "$1" in
        git) show_git_aliases ;;
        coreutils) show_coreutils_aliases ;;
        yarn) show_yarn_aliases ;;
        pnpm) show_pnpm_aliases ;;
        shortcuts) show_shortcuts ;;
        special) show_special_aliases ;;
        functions) show_functions ;;
        *) show_help ;;
    esac
fi
