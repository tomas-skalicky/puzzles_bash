#!/usr/bin/env bash

set -e

#-------------------------------------------------------------------------------

sum() {
    local -r numbers=("$@")
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local sum=0
    for i in "${tape[@]}"; do
        (( sum += i ))
    done
    echo $sum
}

#-------------------------------------------------------------------------------

solve() {
    local -r tape=("$@")
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if (( "${#tape[@]}" < 2 )); then
        echo -1
        return 0
    fi
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local -r tape_sum=$(sum $@)
    local current_left_part_sum=0
    local current_right_part_sum=$tape_sum
    local min_difference
    local -r max_excluded=$((${#tape[@]} - 1))
    for ((i=0; i < max_excluded; ++i)); do
        local current_value=${tape[$i]}
        (( current_left_part_sum += current_value ))
        (( current_right_part_sum -= current_value ))
        local current_difference=$((current_left_part_sum - current_right_part_sum))
        current_difference=${current_difference#-}
        if [[ -z $min_difference ]] || (( current_difference < min_difference )); then
            min_difference=$current_difference
        fi
    done
    echo $min_difference
}

#-------------------------------------------------------------------------------

run_test() {
    local -r expected_min_difference=$1
    local -r tape=("${@:2}")
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local -r actual_result=$(solve "${tape[@]}")
    if (( actual_result != expected_min_difference )); then
        printf 'Min difference in tape ['
        printf '%d, ' "${tape[@]}"
        printf '] should equal to %d, not %d\n' "$expected_min_difference" \
                                                "$actual_result"
        exit 1
    fi
}

#-------------------------------------------------------------------------------

main() {
    run_test -1 1
    run_test 1 1 2
    run_test 0 1 2 3
    run_test 2 1 0 -1
    run_test 1 3 1 2 4 3
    printf '%s\n' SUCCESS
}

#-------------------------------------------------------------------------------

main

