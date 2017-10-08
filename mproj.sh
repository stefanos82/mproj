#!/bin/bash

# Not a portable method, but a useful hack nevertheless.
location="$(dirname "$(readlink -e "$(command -v mproj)")")"

version="2.0.0"

std_flag=
project_name=
compiler=
file_extension=

mk_template() {
    if [ ! -f Makefile ]
    then
        cat > Makefile <<EOF
CC = $compiler

SRC := src
INCLUDE := include

INC = -I \$(INCLUDE)

FLAGS ?= -Wall
FLAGS += -pedantic
FLAGS += -std=$std_flag
FLAGS += -O2

OBJDIR := obj
BINDIR := bin

TARGET = \$(BINDIR)/\$(notdir \$(basename $project_name))

SOURCES = \$(wildcard \$(SRC)/*.$file_extension)
TMPOBJ = \$(patsubst %.$file_extension, %.o, \$(notdir \$(SOURCES)))
OBJECTS = \$(addprefix \$(OBJDIR)/, \$(TMPOBJ))

all: \$(TARGET)

\$(TARGET): \$(OBJECTS)
	\$(CC) -o \$@ \$(OBJECTS)

build:
	@mkdir -p \$(OBJDIR) \$(BINDIR)

\$(OBJECTS): \$(OBJDIR)/%.o: \$(SRC)/%.$file_extension
	\$(CC) \$(FLAGS) \$(INC) -c \$< -o \$@

full: clean build all

.PHONY: clean build all

clean:
	@echo "Cleaning target and object files..."
	@rm -rf \$(TARGET) \$(OBJDIR) \$(BINDIR)
	@find . -type f -iname "*.gch" -delete

	@echo "All clear!"

.DEFAULT_GOAL := full
EOF
    fi
}

version() {
	cat <<EOF
mproj, version $version
Copyright (C) $(date +'%Y') Stefanos Sofroniou
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
}

guidance() {
    cat <<EOF
    Usage: $(basename "$0") [OPTIONS] <project-name>

    -h, --help:

        It prints this help message and exit.

    -c89, --c89:

        It generates a C project with C89 flag.

    -c99, --c99:

        It generates a C project with C99 flag.

    -c11, --c11:

        It generates a C project with C11 flag.

    -c++98, --c++98:

        It generates a C++ project with C++98 flag.

    -c++11, --c++11:

        It generates a C++ project with C++11 flag.

    -c++14, --c++14:

        It generates a C++ project with C++14 flag.

    -c++17, --c++17:

        It generates a C++ project with C++17 flag.

    -v, --version:
    
        Displays project version and License.

EOF
}

skeleton() {
    if [ ! -d src ] && [ ! -d include ]
    then
        mkdir src include
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c89" ]
    then
        if [ ! -f src/main.c ]
        then
            touch src/main.c
            cat "$location/samples/c/c89.txt" > src/main.c
        fi
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c99" ]
    then
        if [ ! -f src/main.c ]
        then
            touch src/main.c
            cat "$location/samples/c/c99.txt" > src/main.c
        fi
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c11" ]
    then
        if [ ! -f src/main.c ]
        then
            touch src/main.c
            cat "$location/samples/c/c11.txt" > src/main.c
        fi
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++98" ]
    then
        if [ ! -f src/main.cpp ]
        then
            touch src/main.cpp
            cat "$location/samples/cpp/cpp98.txt" > src/main.cpp
        fi
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++11" ]
    then
        if [ ! -f src/main.cpp ]
        then
            touch src/main.cpp
            cat "$location/samples/cpp/cpp11.txt" > src/main.cpp
        fi
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++14" ]
    then 
        
        # Special thanks to cppreference website for providing
        # this example.
        # I use it for demonstrative purposes and to check that
        # my actual flag mechanism works as expected.
        if [ ! -f src/main.cpp ]
        then
            touch src/main.cpp
			cat "$location/samples/cpp/cpp14.txt" > src/main.cpp
        fi
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++17" ]
    then 
        
        # Again, special thanks to cppreference website for providing
        # this example.
        # I use it for demonstrative purposes and to check that
        # my actual flag mechanism works as expected.
        if [ ! -f src/main.cpp ]
        then
            touch src/main.cpp
			cat "$location/samples/cpp/cpp17.txt" > src/main.cpp
        fi
    fi
}

if [ $# -eq 0 ]; then
    echo
    echo "Illegal number of arguments. Add -h or --help flags for assistance."
    echo
fi

while [ "$1" ]; do
    case $1 in
        -c89 | --c89 )
            compiler=gcc
            file_extension=c
            std_flag=c89

            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi
            
            shift

            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template
            
            exit
            ;;

        -c99 | --c99 )
            compiler=gcc
            file_extension=c
            std_flag=c99

            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi
            
            shift

            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template

            exit
            ;;

        -c11 | --c11 )
            compiler=gcc
            file_extension=c
            std_flag=c11
            
            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi
            
            shift
            
            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template

            exit
            ;;

        -c++98 | --c++98 )
            compiler=g++
            file_extension=cpp
            std_flag=c++98

            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi
            
            shift

            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template

            exit
            ;;

        -c++11 | --c++11 )
            compiler=g++
            file_extension=cpp
            std_flag=c++11

            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi

            shift

            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template

            exit
            ;;

        -c++14 | --c++14 )
            compiler=g++
            file_extension=cpp
            std_flag=c++14
            
            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi
            
            shift

            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template

            exit
            ;;

        -c++17 | --c++17 )
            compiler=g++
            file_extension=cpp
            std_flag=c++17
            
            if [ -z "$2" ]
            then
                project_name="${std_flag}_demo"
                echo
                echo "Second argument was not provided."
                echo "Project's default name is '$project_name'."
                echo
            else
                project_name=$2
            fi
            
            shift

            mkdir -p "$project_name"
            cd "$project_name" || { printf "Could not change to directory." >&2; exit 1; }

            skeleton
            mk_template

            exit
            ;;

        -h | --help )
            guidance
            exit
            ;;

        -v | --version )
            version
            exit
            ;;

        * )
            guidance
            exit
            ;;
    esac

    shift
done

exit 0

