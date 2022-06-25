#!/bin/bash

string1="Paris, Berlin, Prague"
readarray -td", " tmp_arr1 <<<"$string1"; declare -p tmp_arr1;

string2="France, Germany, Czech"
readarray -td", " tmp_arr2 <<<"$string2"; declare -p tmp_arr2;

string3="Paris, France, Romania"
readarray -td", " tmp_arr3 <<<"$string3"; declare -p tmp_arr3;
