#!/bin/bash


# Rename this script to `compile` and add to your path


# Defind colors
red="\033[38;2;255;0;0m"
green="\033[38;2;0;255;0m"
blue="\033[38;2;0;0;255m"
yellow="\033[38;2;180;255;0m"
some_color="\033[38;2;50;100;180m"
no_col="\033[0m"
sky="\033[38;2;80;254;200m"


# Check if the script is being run as sudo
check_sudo() {
    if ! sudo -v ; then
        sudo -v
    fi
}   


# Saves the config in the home dir
save_config() {
    purge="$1"
    if [[ $purge == "purge" ]]; then
        echo "Purging configuration..."
        echo > ~/"${file_name}"
        return 0;
    fi
    
    # Debug Messages
    # echo "Saving Your Configs:"
    # echo "Config file: ~/$file_name"
    # echo "Project Name: $set_project_name : '$ProjectName'"
    # echo "C-plus-plus directory: $set_cpp_dir_name : '$CPP_DirName'"
    # echo "C directory: $set_c_dir_name : '$C_DirName'"
    # echo "Compiler: $set_given_compiler : '$Default_Compiler'"
    # echo "Verbose: $verbose"
    # echo -e "\n\n"

    echo > ~/"${file_name}"
    [[ $set_project_name == "true" ]] && echo "bool_project_name='true'" >> ~/"${file_name}"
    [[ $verbose == "on" ]] && echo "verbose='on'" >> ~/"${file_name}"
    [[ $verbose == "off" ]] && echo "verbose='off'" >> ~/"${file_name}"
    [[ $set_project_name == "true" ]] && echo "set_project_name='true'" >> ~/"${file_name}"
    [[ $set_given_compiler == "true" ]] && echo "Default_Compiler='${Compiler}'" >> ~/"${file_name}" 
    echo "CPP_DirName='${CPP_DirName}'" >> ~/"${file_name}"
    echo "C_DirName='${C_DirName}'" >> ~/"${file_name}"
    echo "ProjectName='${ProjectName}'" >> ~/"${file_name}"
}


Install_Tool() {
    # install tool based on package manger
    utility="$1"
    echo -e "Checking if '${green}${utility}${no_col} installed on your system...'"
    if ! command -v "$utility" &> /dev/null ; then
        echo -e "${green}${utility}${no_col} Not found\nWould you like to install it? [yes/no]"
        read -r yes_no
        if [[ $yes_no =~ ^("y"|"Y"|"yes"|"Yes"|"YES"|"YEs"|"YeS"|"yES"|"yES")$ ]]; then
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

            if [[ $? -eq 0 ]]; then
                echo -e "'${utility} installed successfully'"
                return 0
            else
                echo -e "${red}[ERROR]:${no_col} '$utility' cannot be installed"
                return 1
            fi
        fi
    else
        echo -e "'${green}${utility}${no_col}' already installed"
        return 0
    fi
}


Create_Sub_Dirs() {
    # Create sub-directories
    local dirs=("bin" "asm" "obj" "pre")
    local ParentDir="$1"
    for dir in "${dirs[@]}";do
        if [[ ! -d ./$dir ]]; then
            mkdir -p "${ParentDir}/${dir}" && chown $USER:$USER "${ParentDir}/$dir"
        fi
    done
}


Help_Message() {
    # Prints Help message and exit
    echo "Usage $0 [option] [files]"
    echo -e "\nOptions:"
    echo "-d, --dir, --directory      : Create the default directories (C++_Directory) (C_Directory) 
                                        with sub-directories (bin, asm, obj, pre) in the current directory."
    echo "-dn, --dir-name             : Create directories with user defined names. User will be prompted to enter names for:"
    echo "                               - Project Directory"
    echo "                               - C++ directory"
    echo "                               - C directory"
    echo "-t, -tr, -tree              : Show all your files"
    echo "-v, --verbose               : Set verbose 'on'"
    echo "-p, -r                     : Purge Config File"
    echo "-c, --compiler [compiler]   : Specify the compiler (default 'gcc')"
    echo "-h, --help                  : Display this help message and exit."
}


Create_Dirs() {
    local is_project_dir="$1"
    local is_cpp_dir="$2"
    local is_c_dir="$3"
    local no_error=0

    if [[ $is_project_dir == "true" && ! -d "${ProjectName}" ]]; then
        # Create Project Directory
        mkdir -p "${ProjectName}"
        if [[ $? -ne 0 ]]; then
            echo -e "${blue}[ERROR]:${no_col} Failed to create Project Directory '${blue}${ProjectName}${no_col}'"; exit 1;
        fi

        # Handle C-plus-plus directory creation 
        if [[ $is_cpp_dir == "true" && ! -d "${ProjectName}/${CPP_DirName}" ]]; then
            mkdir -p "${ProjectName}/${CPP_DirName}"
            if [[ $? -ne 0 ]]; then
                echo -e "${red}[ERROR]:${no_col} Failed to Create '${blue}${CPP_DirName}${no_col}'"; exit 1;
            fi 
            Create_Sub_Dirs "${ProjectName}/${CPP_DirName}"
            no_error=$(( $no_error + $? ))
        fi
        # Handle C directory creation
        if [[ $is_c_dir == "true" && ! -d "${ProjectName}/${C_DirName}" ]]; then
            mkdir -p "${ProjectName}/${C_DirName}"
            if [[ $? -ne 0 ]]; then
                echo -e "${red}[ERROR]:${no_col} Failed to create '${blue}${C_DirName}${no_col}'"; exit 1;
            fi 
            Create_Sub_Dirs "${ProjectName}/${C_DirName}"
            no_error=$(( $no_error + $? ))
        fi

        if [[ $no_error -eq 0 ]]; then
            echo -e "${yellow}Created ${ProjectName}${no_col}"
            tree ${ProjectName} 
        fi
        
    else 
        # C-plus-plus directory creation handler
        if [[ $is_cpp_dir == "true" && ! "$CPP_DirName" ]]; then
            mkdir -p "${CPP_DirName}"
            if [[ $? -ne 0 ]]; then
                echo -e "${red}[ERROR]:${no_col} Failed to create '${blue}${CPP_DirName}${no_col}'"; exit 1;
            fi
            Create_Sub_Dirs "${CPP_DirName}"
            echo -e "${yellow}Created ${CPP_DirName}${no_col}"
            tree ${CPP_DirName} 
        fi

        # C directory creation handler
        if [[ $is_c_dir == "true" && ! -d "${C_DirName}" ]]; then
            mkdir -p "${C_DirName}"
            if [[ $? -ne 0 ]]; then
                echo -e "${red}[ERROR]:${no_col} Failed to create '${blue}${C_DirName}${no_col}'"; exit 1;
            fi
            Create_Sub_Dirs "${C_DirName}"
            echo -e "${yellow}Created ${C_DirName}${no_col}"
            tree ${C_DirName}
        fi
        
    fi

}


Compile_The_Source() {
    local compile_tool="$1"
    local source_file="$2"
    local target_dir="$3"
    local source_fileWithoutExt="${source_file%.*}"

    # Check if given tool exist
    if ! command -v "$compile_tool" &> /dev/null ; then
        echo -e "${red}[ERROR]:${no_col} Compile tool '"${compile_tool}"' not found"
        return 1 
    fi
    
    if [[ ! -d $target_dir ]]; then
        echo -e "The path doesn't exist '${blue}${target_dir}${no_col}'"
        echo -e "Can't Compile '${green}${source_file}${no_col}'"
        return 1
    fi
    echo -e "${yellow}Compiling... ${sky}'$source_file'${no_col}${no_col}"
    # Compile to BinaryExecutable
    $compile_tool $source_file -o "${target_dir}/bin/${source_fileWithoutExt}.bin" && \
    [[ $verbose == "on" ]] && echo -e "${some_color}${target_dir}/bin/${no_col}${green}${source_fileWithoutExt}.bin${no_col}"
    # Generate Assembly file
    $compile_tool -S $source_file -o "${target_dir}/asm/${source_fileWithoutExt}.asm" && \
    [[ $verbose == "on" ]] && echo -e "${some_color}${target_dir}/asm/${no_col}${green}${source_fileWithoutExt}.bin${no_col}"
    # Compile to Object file
    $compile_tool -c $source_file -o "${target_dir}/obj/${source_fileWithoutExt}.obj" && \
    [[ $verbose == "on" ]] && echo -e "${some_color}${target_dir}/obj/${no_col}${green}${source_fileWithoutExt}.bin${no_col}"
    # Preprocesses the file
    $compile_tool -E $source_file -o "${target_dir}/pre/${source_fileWithoutExt}.pre" && \
    [[ $verbose == "on" ]] && echo -e "${some_color}${target_dir}/pre/${no_col}${green}${source_fileWithoutExt}.bin${no_col}"
}


# Default Names if not provided
current_path=$(realpath .)
USER="$USER"


# Project defaults
file_name=".compile_script.conf"
set_project_name="false"
set_cpp_dir_name="default"
set_c_dir_name="default"
set_given_compiler="false"
verbose="off"

Default_Compiler="gcc"
ProjectName="Programming_Dir"
C_DirName="C_directory"
CPP_DirName="C++_directory"


if [[ $# -eq 0 ]]; then
    Help_Message
    exit 1
fi


if ! command -v tree &> /dev/null; then
    echo "Tree Not found"
    Install_Tool "tree"
fi


if ! command -v gcc &> /dev/null; then
    echo "gcc not found"
    Install_Tool "gcc"
fi
    

# Check if the file is being run as sudo
check_sudo


if [[ -f ~/"${file_name}" ]]; then
    source ~/"${file_name}"
else
    touch ~/"${file_name}" && sudo chown $USER:$USER ~/"${file_name}"
fi


## Debug messages
# echo "Your Configs Before Save:"
# echo "Config file: ~/$file_name"
# echo "Project Name: $set_project_name : '$ProjectName'"
# echo "C-plus-plus directory: $set_cpp_dir_name : '$CPP_DirName'"
# echo "C directory: $set_c_dir_name : '$C_DirName'"
# echo "Compiler: $set_given_compiler : '$Default_Compiler'"
# echo "Verbose: $verbose"
# echo -e "\n\n"


# Loop through flags to process user input
for flags in "$@"; do
    case $flags in
        -d|--dir|--directory)
            echo "Creating Directories With thier default names"
            echo -e "'${blue}${CPP_DirName}${no_col}' '${blue}${C_DirName}${no_col}'"
            set_cpp_dir_name="true"
            set_c_dir_name="true"
            bool_project="false"
            Create_Dirs
            ;;
        -dn|--dir-name|--directory-name)

            # Get Project directory name
            echo -e "Enter you Project Name (default '${blue}${ProjectName}${no_col}')"
            read NewProject_name
            [[ -n "$NewProject_name" ]] && { ProjectName="$NewProject_name" ; set_project_name="true" ; }

            # Get C++ Project directory name
            echo -e "Enter your C++ Project Name (default '${blue}${CPP_DirName}${no_col}')"
            read NewCPP_name
            [[ -n $NewCPP_name ]] && { CPP_DirName="$NewCPP_name" ; set_cpp_dir_name="true" ; }

            # Get C Project directory name
            echo -e "Enter your C Project Name (default '${blue}${C_DirName}${no_col}')"
            read NewC_name
            [[ -n $NewC_name ]] && { C_DirName="$NewC_name" ; set_c_dir_name="true" ; }

            # Call the function to create dirs based on user input
            Create_Dirs "$set_project_name" "$set_cpp_dir_name" "$set_c_dir_name"
            ;;
        -c|--compiler|--Default_Compiler|--compiler-name)
            echo "Enter you compiler name: "
            read New_Compiler
            [[ -n $New_Compiler ]] && Default_Compiler="$New_Compiler"  
            Install_Tool "$Default_Compiler" && set_given_compiler="true"
            ;;
        -v|-vo|-v-on|--verbose-on|-verbose|--verbose|--Verbose)
            verbose="on"
            ;;
        -vf|--v-off|-v-off|-verbose-off|--verbose-off)
            verbose="off"
            ;;
        -r|--remove|--purge)
            save_config "purge"
            exit 0
            ;;
        -t|-tr|-tree|--tree|-Tree|--Tree|-TREE)
            [[ -d "${ProjectName}" ]] && tree "$ProjectName"
            [[ -d "${CPP_DirName}" ]] && tree "$CPP_DirName"
            [[ -d "${C_DirName}" ]] && tree "$C_DirName" 
            ;;
        -h|--help|--Help)
            Help_Message
            ;;
    esac
done


# Loop through given source files
for source_file in "$@"; do
    if [[ "${source_file}" != -* ]]; then
        if [[ "${source_file}" == *.cpp  ]]; then
            # CPP Files
            [[ $set_project_name == "false" && ! -d "${CPP_DirName}" ]] && Create_Dirs "$set_project_name" "true" "false"
            [[ $set_project_name == "true" &&  ! -d "${ProjectName}/${CPP_DirName}" ]] && Create_Dirs "$set_project_name" "true" "false"

            if [[ $Default_Compiler == "gcc" ]]; then
                [[ -d "$ProjectName" ]] && Compile_The_Source "g++" "$source_file" "${ProjectName}/${CPP_DirName}"
                [[ ! -d "$ProjectName" ]] && Compile_The_Source "g++" "$source_file" "${CPP_DirName}"
            else
                [[ -d "$ProjectName" ]] && Compile_The_Source "$Default_Compiler" "$source_file" "${ProjectName}/${C_DirName}"
                [[ ! -d "$ProjectName" ]] && Compile_The_Source "$Default_Compiler" "$source_file" "${C_DirName}"
            fi
        elif [[ "${source_file}" == *.c ]]; then
            # C Files
            [[ $set_project_name == "false" && ! -d "${C_DirName}" ]] && Create_Dirs "$set_project_name" "false" "true"
            [[ $set_project_name == "true" &&  ! -d "${ProjectName}/${C_DirName}" ]] && Create_Dirs "$set_project_name" "false" "true"
            
            [[ -d "$ProjectName" ]] && Compile_The_Source "$Default_Compiler" "$source_file" "${ProjectName}/${C_DirName}"
            [[ ! -d "$ProjectName" ]] && Compile_The_Source "$Default_Compiler" "$source_file" "${C_DirName}"
        fi
    fi
done


save_config
