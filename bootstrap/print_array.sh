#!/bin/bash

# print a data collection
print_collection() {

    # helper to get array value at key
    value() { eval echo \${$1[$2]}; }

    for k in $(value $1 keys)
    do
        echo "$2$k = $(value $1 $k)"
    done

    for c in $(value $1 children)
    do
        echo -e "$2$c\n$2{"
        print_collection $c "  $2"
        echo "$2}"
    done
}

function collection_print() {
    local __i__ __val__
    local __arr__=$1
    for __i__ in $( eval echo "\${$__arr__[keys]}" ); do
        __val__="$( eval echo "\"\${$__arr__[$__i__]}\"" )"
        #__array_print "$__val__" "$__i__"
        echo "$2$__i__ = $__val__"
    done

    for __c__ in $( eval echo "\${$__arr__[children]}" ); do
        echo -e "$2$__c__$2{\n"
        collection_print "$__c__" "  $2"
        echo -e "\n$2}"
    done

}

function array_map() {
    local __i__ __val__ __arr__=$1; shift
    for __i__ in $( eval echo "\${!$__arr__[@]}" ); do
        __val__="$( eval echo "\"\${$__arr__[$__i__]}\"" )"
        if [[ "$1" ]]; then
            "$@" "$__val__" $__i__
        else
            echo "Key:<$__i__>, Value: <$__val__>"
        fi
    done
}

# Print bash array in the format "i <val>" (one per line) for debugging.
function array_print() { array_map $1 __array_print; }
function __array_print() { echo "$2 = <$1>"; }


collection_print "$1" "  "
