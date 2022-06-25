#!/bin/bash
# An example showing how to use Yay


# helper to get array value at key
value() { eval echo \${$1[$2]}; }

# print a data collection
print_collection() {
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
