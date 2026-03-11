#!/usr/bin/env bash

export WIN_USERNAME="$(powershell.exe -Command 'echo $env:UserName' | tr -d '\r')"

function main() {
    printf "\e[34minitializeCommand\e[0m\n"

    SCRIPT_START=$(date +%s%3N)

    printf "\e[34m${WIN_USERNAME}\e[0m\n"

    SCRIPT_END=$(date +%s%3N)

    TOTAL_DURATION=$((SCRIPT_END - SCRIPT_START))
    SECONDS=$((TOTAL_DURATION / 1000))
    MILLISECONDS=$((TOTAL_DURATION % 1000))
    printf "\e[32mSetup complete! Total time: %d.%03d [s]\e[0m\n" $SECONDS $MILLISECONDS
}

main
