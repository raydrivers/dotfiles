#!/usr/bin/env fish

set branch (git symbolic-ref --short HEAD 2>/dev/null)
if test -z "$branch"
    echo "Error: Could not determine the current branch."
    exit 1
end

set remote (git remote | head -n 1)
if test -z "$remote"
    echo "Error: No remote found."
    exit 1
end

if test (count $argv) -eq 2
    set remote $argv[1]
    set branch $argv[2]
else if test (count $argv) -eq 1
    set remote $argv[1]
end

git fetch $remote

set commit (git merge-base HEAD "$remote/$branch")
if test -z "$commit"
    echo "Error: Could not determine merge base. Check if the branch exists on remote."
    exit 1
end

git rebase --interactive "$commit" --autosquash
