#!/usr/bin/env fish

set count 1
if test (count $argv) -ge 1
    set count $argv[1]
end

if not string match -qr '^[0-9]+$' -- $count
    echo "Error: Argument must be a number."
    echo "Usage: git last [count]"
    exit 1
end

if test $count -eq 1
    git log -1 --stat HEAD
else
    git log -$count --oneline --decorate --graph
end
