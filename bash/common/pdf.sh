#!/usr/bin/env bash

pdf-extract() {
    # extract pages from PDF, uses 3 arguments:
    # $1 is the input file
    # $2 is the first page of the range to extract
    # $3 is the last page of the range to extract
    # output file will be named "inputfile_pXX-pYY.pdf"
    # usage:
    #   pdf-extract $input $first $last
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=${2} -dLastPage=${3} -sOutputFile=${1%.pdf}_p${2}-p${3}.pdf ${1}
}

pdf-merge()
{   # merge several PDF files to a single one, uses multiple arguments
    # $1 is the name of the output file
    # remaining argument(s) ar the names of the PDFs to merge.
    # usage:
    #   pdf-merge $outfile $infile1 $infile2 ...
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=${1} "$@"
}
