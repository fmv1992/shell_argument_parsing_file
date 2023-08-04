#! /usr/bin/env bash

# Halt on error.
set -euxo pipefail

# Go to execution directory.
{ cd "$(dirname $(readlink -f "${0}"))" && git rev-parse --is-inside-work-tree > /dev/null 2>&1 && cd "$(git rev-parse --show-toplevel)"; } || cd "$(dirname "$(readlink -f ${0})")"
# Close identation: }

export REFERENCE_DIR="${REFERENCE_DIR:-}"
export REC_ARGUMENTS=${REFERENCE_DIR:-}/usr/local/share/shell_argument_parsing_file/recfiles/recfile_test_01.rec

declare -A arguments

source ${REFERENCE_DIR}/usr/local/lib/shell_argument_parsing_file/shell_argument_parsing_file

# Declare a few test variables.
declare -A test_array_01
test_array_01[fruit]=Mango
test_array_01[bird]=Cockatail
test_array_01[flower]=Rose
test_array_01[animal]=Tiger
# The empty array.
declare -A test_array_02
# This one is equal to `test_array_01`.
declare -A test_array_03
test_array_03[fruit]=Mango
test_array_03[bird]=Cockatail
test_array_03[flower]=Rose
test_array_03[animal]=Tiger
declare -A test_array_04
test_array_04[us]=washington

# All arrays are equal to itself.
for arr in test_array_01 test_array_02 test_array_03 test_array_04; do
    _associative_arrays_are_equal arr arr > /dev/null 2>&1
done

# All arrays are different from themselves, except arrays 1 and 3.
for arr01 in test_array_01 test_array_02 test_array_03 test_array_04; do
    for arr02 in test_array_01 test_array_02 test_array_03 test_array_04; do
        is_equal="$(_associative_arrays_are_equal $arr01 $arr02 || true)"
        if [[ $is_equal == 'true' ]]; then
            [[ $arr01 == $arr02 ]] || [[ "$(printf "%s\n" $arr01 $arr02 | sort -u | paste --serial --delimiters ',')" == 'test_array_01,test_array_03' ]]
        else
            [[ $arr01 != $arr02 ]]
        fi
    done
done

[[ $(_associative_arrays_are_equal test_array_02 test_array_01) == false ]]
[[ $(_associative_arrays_are_equal test_array_01 test_array_02) == false ]]
[[ $(_associative_arrays_are_equal test_array_01 test_array_03) == true ]]
[[ $(_associative_arrays_are_equal test_array_03 test_array_01) == true ]]

declare -A arguments
parse $REC_ARGUMENTS arguments '--help -i a'
declare -A expected01
expected01[help]='true'
expected01[i]="'a'"
expected01[rest_n]=0
_associative_arrays_are_equal arguments expected01 > /dev/null 2>&1
unset arguments expected01

# Should fail.
declare -A arguments
parse $REC_ARGUMENTS arguments '--help --input -- a'
declare -A expected02
expected02[help]='true'
expected02[input]="'--'"
expected02[rest_n]=1
expected02[rest0]="'a'"
_associative_arrays_are_equal arguments expected02 > /dev/null 2>&1

# vim: set filetype=sh fileformat=unix nowrap:
