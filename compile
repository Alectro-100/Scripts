#!/bin/bash

# Checks if any arguments
if [[ $# -lt 1 ]]; then 
    echo -e "${red}Usage: ./compile <file1.cpp file2.c ...>${no_col}"
    exit 1
fi

files="$@"

# Create neccessary directory
function create_dirs() {
    dir_name="$1"
    
    [[ ! -d ./bin ]] && mkdir ./bin
    [[ ! -d ./asm ]] && mkdir ./asm
    [[ ! -d ./obj ]] && mkdir ./obj
    [[ ! -d ./pre ]] && mkdir ./pre
}


function COMPILE() {
    c_lang="$1"
    compile_file="$2"
    ${c_lang} ../$file -o $(realpath ./bin/${compile_file}.bin) -Wall -std=c++11
    ${c_lang} -S ../$file -o $(realpath ./asm/${compile_file}.asm)
    ${c_lang} -c ../$file -o $(realpath ./obj/${compile_file}.obj)
    ${c_lang} -E ../$file -o $(realpath ./pre/${compile_file}.i)
    cd ../
    echo -e "\n"
}

# Compile the given files
for file in ${files}; do
    if [[ -f $file ]]; then
        if [[ $file == *.cpp ]];then
            [[ ! -d ./C++_files ]] && mkdir "./C++_files"
            cd "./C++_files"
            create_dirs "./C++_files"
            echo -e "${some_color}Compiling FILE: $file${no_col}"
            COMPILE "g++" "${file%.cpp}"
        
        elif [[ $file == *.c ]];then
            [[ ! -d ./C_files ]] && mkdir "./C_files"
            cd "./C_files"
            create_dirs "C_files"
            echo -e "${some_color}Compiling FILE: $file${no_col}"
            COMPILE "gcc" "${file%.c}"
        fi
    else
        echo -e "${red}[ERROR]: file ${file} does not exist.${no_col}"
    fi
done
