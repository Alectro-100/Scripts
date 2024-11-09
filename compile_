#!/bin/bash

# Colors
red="\033[38;2;255;0;0m"
green="\033[38;2;0;255;0m"
blue="\033[38;2;10;100;200m"
yellow="\033[38;2;255;234;10m"
some_color="\033[38;2;200;150;180m"
no_col="\033[0m"

# Checks if any arguments
if [[ $# -lt 1 ]]; then 
    echo -e "${red}Usage: ./compile <file1.cpp file2.c ...>${no_col}"
    exit 1
fi

files="$@"

# Create neccessary directory
function create_dirs() {
    dir_name="$1"
    
    [[ ! -d ./bin ]] && mkdir ./bin && echo -e "${yellow}Creating ${blue}'$(realpath ./bin)'${no_col} directory for binary files.${no_col}"
    [[ ! -d ./asm ]] && mkdir ./asm && echo -e "${yellow}Creating ${blue}'$(realpath ./asm)'${no_col} directory for assembly files.${no_col}"
    [[ ! -d ./obj ]] && mkdir ./obj && echo -e "${yellow}Creating ${blue}'$(realpath ./obj)'${no_col} directory for object files.${no_col}"
    [[ ! -d ./pre ]] && mkdir ./pre && echo -e "${yellow}Creating ${blue}'$(realpath ./pre)'${no_col} directory for preprocessor files.${no_col}"
}


function COMPILE() {
    c_lang="$1"
    compile_file="$2"
    ${c_lang} ../$file -o $(realpath ./bin/${compile_file}.bin) -Wall && echo -e "Executable at ${yellow}$(realpath ./bin/${compile_file}.bin)${no_col}"
    ${c_lang} -S ../$file -o $(realpath ./asm/${compile_file}.asm) && echo -e "Assembly at ${yellow} $(realpath ./asm/${compile_file}.asm)${no_col}"
    ${c_lang} -c ../$file -o $(realpath ./obj/${compile_file}.obj) && echo -e "Object file at ${yellow}$(realpath ./obj/${compile_file}.obj)${no_col}"
    ${c_lang} -E ../$file -o $(realpath ./pre/${compile_file}.i) && echo -e "Preprocessed file at ${yellow}$(realpath ./pre/${compile_file}.i)${no_col}"
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


