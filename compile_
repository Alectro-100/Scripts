#!/bin/bash

# [[[[        DOCUMENTATION        ]]]]

# Usage:
# ./script_name.sh [options] [files]

# Options:
#   -d, --dir, --directory      : Create the default directories (bin, asm, obj, pre) in the current directory.
#   -dn, --dir-name             : Create directories with custom names. User will be prompted to enter names for:-
#                                 - C++ directory
#                                 - C directory
#   -c, --compiler [compiler]   : Specify the compiler default 'gcc'
#   -h, --help                  : Display this help message and exit.


# Rename this script to your preference
# Example usage:
#   1. Run the script with no arguments to create default directories:
#        ./compile_script -d
#
#   2. Run the script with custom directory names:
#        ./compile_script -dn
#
#   3. Compile a C++ file with a specific compiler:
#        ./compile_script -c g++ example.cpp
#
# Author: [Raj Kushwaha]



# Setting up varibales
nargs="$@"
USER="$USER"

# Defind colors
red="\033[38;2;255;0;0m"
green="\033[38;2;0;255;0m"
blue="\033[38;2;0;0;255m"
yellow="\033[38;2;180;255;0m"
no_col="\033[0m"
sky="\033[38;2;80;254;200m"



# Setting up golbal variables
# Check for arguments
if [[ -z $nargs ]]; then
    echo -e "${red}[ERROR]${no_col}: At least one parameter expected"
    exit 1
fi




# Check if the script is being run as sudo
check_sudo() {
    if ! sudo -v ; then
        sudo -v
    fi
}   



# Saves the direcotry names in home
save_config() {
    local CPP="$1"
    local C="$2"
    echo "CPP_DirName='$CPP'" > ~/.compile_script_config.txt
    echo "C_DirName='$C'" >> ~/.compile_script_config.txt
}




Install_tool() {
    # install toll based on package manger
    utility="$1"
    if command -v "$utility" &> /dev/null ; then
        echo "'$utility'is already installed"
    fi
    if command -v dnf &> /dev/null ; then
        sudo dnf install "$utility"
    elif command -v apt &> /dev/null ; then
        sudo apt install "$utility" -y
    elif command -v pacman &> /dev/null ; then
        sudo pacman -S "$utility" --noconfirm
    elif command -v zypper &> /dev/null ; then
        sudo zypper install "$utility"
    elif command -v yum &> /dev/null ; then
        sudo yum install "$utility"
    elif command -v snap &> /dev/null ; then
        sudo snap install "$utility" 
    elif command -v flatpak &> /dev/null ; then
        flatpak install flathub "$utility"
    fi
    echo -e "'$utility installed successfully'"
}




CREATE_SUB_DIRS() {
    # Create sub-directories
    local dirs=("bin" "asm" "obj" "pre")
    local ParentDir="$1"
    cd $ParentDir
    for dir in "${dirs[@]}";do
        if [[ ! -d ./$dir ]]; then
            mkdir $dir && sudo chown $USER:$USER ./$dir
        fi
    done
    cd ../
}




help_message() {
    # Prints Help message and exit
    echo "Options:"
    echo "-d, --dir, --directory      : Create the default directories (bin, asm, obj, pre) in the current directory."
    echo "-dn, --dir-name             : Create directories with custom names. User will be prompted to enter names for:"
    echo "                               - C++ directory"
    echo "                               - C directory"
    echo "-c, --compiler [compiler]   : Specify the compiler default 'gcc'"
    echo "-h, --help                  : Display this help message and exit."
}




CREATE_DIRS() {
    # Create all the necessary directories
    cd $var 
    local Default_DirName="$1"
    
    [[ ! -d ${Default_DirName} ]] && mkdir "$Default_DirName" && sudo chown $USER:$USER "$Default_DirName"
    
    CREATE_SUB_DIRS ${var}/${Default_DirName}

    if ! command -v tree &> /dev/null ; then
        echo -e "Installing ${green}tree${no_col}"
        Install_tool "tree"
    fi
    echo -e "${yellow}Created ${Default_DirName} ${no_col}"
    echo "$( tree ${var}/${Default_DirName})" 
}




COMPILE() {
    local compile_tool="$1"
    local compile_file="$2"
    local compile_fileWithoutExt="${compile_file%.*}"
    local target_dir="$3"

    # Check if given tool exist
    if ! command -v "$compile_tool" &> /dev/null ; then
        echo -e "${red}[ERROR]:${no_col} Compile tool '"${compile_tool}"' not found"
        return 1 # Exit function with error code 1 
    fi

    echo -e "${yellow}Compiling... ${sky}"$compile_file"${no_col}${no_col}"
    # Compile to BinaryExecutable
    $compile_tool $compile_file -o "${target_dir}/bin/${compile_fileWithoutExt}.bin"
    # Generate Assembly file
    $compile_tool -S $compile_file -o "${target_dir}/asm/${compile_fileWithoutExt}.asm"
    # Compile to Object file
    $compile_tool -c $compile_file -o "${target_dir}/obj/${compile_fileWithoutExt}.obj"
    # Preprocesses the file
    $compile_tool -E $compile_file -o "${target_dir}/pre/${compile_fileWithoutExt}.pre" 
}



# Default Names if not provided
CPP_DirName="C++_Dir"
C_DirName="C_Dir"

var=$(realpath .)



# Check if the file is being run as sudo
check_sudo



# If number of arguments are not Empty
if [[ -n $nargs ]]; then
    # Convert 'nargs' to a array to access it's next item based on index
    read -r -a nargs_array <<< ${nargs}
    num=0 
    # Loop only for Given Flags
    for i in ${nargs_array[@]}; do
        nargs_="${nargs_array[$num]}"
        if [[ ${nargs_} =~ ^("-h"|"--help")$ ]]; then
            help_message
            exit 0
        fi
        
        if [[ ${nargs_} =~ ^("-d"|"-dir"|'--dir'|'--directory')$ ]]; then
            # Create directory with default names
            if [[ ! -d "$CPP_DirName" ]] || [[ ! -d "$C_DirName" ]]; then
                CREATE_DIRS "$CPP_DirName"
                CREATE_DIRS "$C_DirName"
                save_config "$CPP_DirName" "$C_DirName"
            fi

        elif [[ $nargs_ =~ ^("-dn"|"-dir-name"|'--dir-name'|'--directory-name')$ ]]; then
            # Create directory with specified names
            echo -e "Name for your C++ directory (Default: ${blue}C++_Dir${no_col})"
            read -r CPP_DirName
            echo -e "Name for your C directory (Defalult: ${blue}C_Dir${no_col})"
            read -r C_DirName
            
            CPP_DirName="${CPP_DirName:-'C++_Dir'}"
            C_DirName="${C_DirName:-'C_dir'}"

            save_config "$CPP_DirName" "$C_DirName"

            CREATE_DIRS "${CPP_DirName}"
            CREATE_DIRS "${C_DirName}"

        elif [[ $nargs_ =~ ('-c'|'--compiler')$ ]]; then
            # Select your compile (GCC, G++, Clang)
            echo -e "Your specified compiler: '${green}${nargs_array[ $num + 1 ]}${no_col}' will be used"
            TOOL="${nargs_array[$num + 1]:-"gcc"}"
            TOOL="${TOOL:-"gcc"}"

        else
            # If No flags were given, just create directories for compilation
            if [[ -f ~/compile_script_config.txt ]]; then
                source ~/.compile_script_config.txt
            fi
            
            if [[ ! -d $CPP_DirName ]] || [[ ! -d $C_DirName ]]; then
                CREATE_DIRS "$CPP_DirName"
                CREATE_DIRS "$C_DirName"
                save_config "$CPP_DirName" "$C_DirName"
            fi
        fi
        (( num++ ))
    done


    num1=0
    # Loop to compile source file 
    for source_file in ${nargs_array[@]}; do
        TOOL="${TOOL:-"gcc"}"
        nargs__="${nargs_array[$num1]}"
        # Check if regular file exists
        if [[ -f $nargs__ ]]; then
            # Check by its extension .cpp
            if [[ $nargs__ == *.cpp ]]; then
                if [[ $TOOL == "gcc" ]]; then
                    COMPILE "g++" "$source_file" "${CPP_DirName}"
                else
                    COMPILE "$TOOL" "$source_file" "${CPP_DirName}"
                fi

            # Check by its extension .c
            elif [[ $nargs__ == *.c ]]; then
                COMPILE "$TOOL" "$nargs__" "${C_DirName}"

            else
                # Check it content to compile
                if [[ ! ${nargs__} == -* ]]; then
                    if  [[ -f ${nargs__} ]]; then
                        if head -n 1 "${nargs__}" | grep -- "^#include\s*<.*\.h" &> /dev/null ; then
                            COMPILE "$TOOL" "${source_file}" "${C_DirName}"
                        elif head -n 1 "${nargs__}" | grep -- "^#include\s*<" &> /dev/null; then
                            COMPILE "$TOOL" "${source_file}" "${CPP_DirName}"
                        fi
                    fi
                fi

                if [[ ! ${nargs__} == -* ]]; then
                    if [[ ! -f ${nargs__} ]]; then
                        echo -e "${red}[ERROR]${no_col}: File '${sky}${nargs__}${no_col}' Doesn't exist"
                    fi
                fi
            fi
        fi
    
        (( num1++ )) 
    done
fi


