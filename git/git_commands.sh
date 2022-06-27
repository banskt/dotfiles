#!/bin/bash

# loaded by interactive.bashrc

git-add() {
    if [ -d .git ] || [ -f .git ]; then
        files=$(git ls-files --modified -o --exclude-standard)
        if [[ ${files} ]]; then
            git ls-files --modified -o --exclude-standard | xargs git add --all
            git status
        else
            echo "No modified files were found"
        fi
    else
        echo "This is not a git repository"
    fi
}
