#!/bin/bash

if [ $# -eq 0 ]; then
	# read stdin, count words and lines

	NUMBERS=(`wc -l -w -m < /dev/stdin`)

	if [ ${NUMBERS[0]} -eq 1 ]; then
		echo Your input contains only one line > /dev/stderr
	fi

	if [ ${NUMBERS[2]} -eq 1 ]; then
		echo Your lines contains only one word > /dev/stderr
	fi

	echo "Your input have" ${NUMBERS[0]} "strings," ${NUMBERS[1]} "words"
	echo ${NUMBERS[@]}

elif [ $1 = -read ]; then
	# reat input, print it out and count lines (and words)

	echo "Please, write me few lines (empy line to quit):"
	# while IFS= read -r -p "Input (empy line to quit): " line; do
	while IFS= read -r line; do
	    [[ $line ]] || break  # break if empty line
	    array+=("$line")
	done

	if [ ${#array[@]} -lt 1 ]; then
		echo Your input contains only one line > /dev/stderr
	else
		printf '%s\n' "${array[@]}" > /dev/stdout
	fi

	printf '%s\n' ${#array[@]}" lines read"


elif [ $# -gt 0 ]; then
	# read arguments as words, count them

	for word in "$@"; do
	    array+=("$word")
	done 

	if [ ${#array[@]} -lt 2 ]; then
		echo Your input contains only one word in line > /dev/stderr
	fi

	printf '%s\n' ${#array[@]}" words read"

fi




#!/bin/sh
#
# Read from stdin, write to stdout, stderr.
#
# :Author: ssin


# tr '[:lower:]' '[:upper:]' < /dev/stdin

# INPUT < /dev/stdin

# if [ -z "$INPUT" ]; then
# 	echo Error > /dev/stderr
# else
# 	echo $INPUT
# fi

# if [ $# -gt 0 ]; then
# 	for line in "$@"; do
# 	    echo "$line"
# 	done 
# else
# 	echo hello

# 	array=()
# 	while IFS= read -r -p "Next item (end with an empty line): " line; do
# 	    [[ $line ]] || break  # break if line is empty
# 	    array+=("$line")
# 	done

# 	printf '%s\n' "Items read:"
# 	printf '  «%s»\n' "${array[@]}"

# 	while read line; do
# 	    my_array=("${my_array[@]}" $line)
# 	done

# 	echo ${my_array[@]}
# fi