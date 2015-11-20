#!/bin/sh

# Declare array for input data (from a PIPE or from ARGS of command line)
declare -a input_array

declare words=0
declare lines=0
each_line_has_one_word=1

let count=0
# If there is STDIN then read STDIN into ${input_array}
if [[ -p /dev/stdin ]] ; then
    while read cur_line ; do
         input_array[$count]="$cur_line"
        ((count++))
    done
# If there is no STDIN but there is ARGS into ${input_array}
elif [ $# -gt 0 ] ; then
    # Get all ARGS into string ${args}
    args=`echo -e "${@}"`
    # Split input data by '\n'
    OLD_IFS=$IFS IFS=$'\n' input_array=($args) IFS=$OLD_IFS
fi

# Get number of lines
lines="${#input_array[@]}"

# If there is neither STDIN nor ARGS
if [ $lines -eq 0 ] ; then
    echo "Error #1: No input defined!" 1>&2
    exit 2
fi

# Get number of words
for cur_line in "${input_array[@]}"
do
    cur_words=`echo "$cur_line" | wc -w`
    if [ $cur_words -gt 1 ] ; then each_line_has_one_word=0 ; fi
    words=$((words+cur_words))
done

if [ $lines -eq 1 ] ; then
    echo "Error #2: The input contains only one line" 1>&2
    exit 2
fi

if [ $each_line_has_one_word -eq 1 ] ; then
    echo "Error #3: The input contain no more than one word in each line!" 1>&2
    exit 2
fi

echo "Count of lines: $lines"
echo "Count of words: $words"
