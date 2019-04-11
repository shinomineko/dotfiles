#!/usr/bin/env fish

function cheat --description "cheat <command>"
    curl cht.sh/"$argv[1]"
end

