#!/bin/bash

### 4. Text File Analyzer
#   - Task: Write a script that takes a text file as input 
#     and displays the number of lines, words, and characters in the file, 
#     as well as the most frequent word.
#   - Concepts: File reading, loops, text processing, word frequency counting, 
#     `awk`, `grep`, `sort`.

error(){
    echo $1
    exit 1
}

# Check the user just provide one argument
if [[ $# != 1 ]]; then
    error "Usage: script filename"
fi

# Check if it's a file and if it exists
if [ ! -f "$1" ];then
    error "File not found!"
fi

filename="$1"

# Calculate the number of lines, words and characters
# wc is the word count command
num_lines=$(wc -l < "$filename")
num_words=$(wc -w < "$filename")
num_chars=$(wc -m < "$filename")

# Find the most frequent word:

# 1. Separate words by newlines (tr -cs '[:alpha:]' '\n')
##### tr command is used to replace characters in a text stream
##### The -c options stands for complement, so the complement of the specified 
##### character class should be replace. Ex. if we say [:alpha:] represent alphabetic characters,
##### the complement is non alphabetic characters.
##### The -s option is used to squeeze multiple occurrences of a newline character into a single one.

# 2. Convert to lowercase (tr 'A-Z' 'a-z')

# 3. Count word frequency (sort | uniq -c)
##### sort command sort the words alphabetically
##### uniq command with -c option count the number of ocurrences of each word
##### It's important to sort before piping to uniq -c, because uniq -c counts 
##### the number of ocurrences of duplicate adjacent lines.
##### As a result we obtain a list of words, each preceded by its frequency
##### Example 4 pepe
#####         6 maria

# 4. Sort by frequency
##### sort command to sort the words by frequency. -n option ensures sorting numerically, -r option in reverse order (from highest to lowest)
##### head to extract the last one

most_frequent_word=$(tr -cs '[:alpha:]' '\n' < "$filename"| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# Display the results
echo "File: $filename"
echo "Lines: $num_lines"
echo "Words: $num_words"
echo "Characters: $num_chars"
echo "Most Frequent Word: $most_frequent_word"
