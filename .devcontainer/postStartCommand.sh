#!/usr/bin/env bash

function main() {
    # メイン関数
    printf "\e[34mpostStartCommand\e[0m\n"

    local script_start=$(date +%s%3N)

    printf "\e[36m- $(uname -a)\e[0m\n"

    local script_end=$(date +%s%3N)
    local total_duration=$((script_end - script_start))
    local seconds=$((total_duration / 1000))
    local milliseconds=$((total_duration % 1000))
    printf "\e[32mSetup complete! Total time: %d.%03d [s]\e[0m\n" $seconds $milliseconds
}

main
