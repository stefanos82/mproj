#!/bin/bash

# Not a portable method, but a useful hack nevertheless.
location="$(dirname "$(readlink -e "$(command -v mproj)")")"

version="4.1.0"

std_flag=
project_name=
compiler=
file_extension=

mk_template() {

    if [ ! -f flags.mk ]
    then
        cat > flags.mk <<EOF
FLAGS ?= -Wall
FLAGS += -Wextra
FLAGS += -pedantic
FLAGS += -std=$std_flag

LDFLAGS ?=

EOF
    fi

    if [ ! -f Makefile ]
    then
        cat > Makefile <<EOF
CCACHE_IS_INSTALLED := \$(shell command -v ccache 2>/dev/null)

ifdef CCACHE_IS_INSTALLED
CCACHE := \$(shell basename \$(CCACHE_IS_INSTALLED))
endif

COMPILER := \$(shell basename \$(shell command -v $compiler 2>/dev/null))

ifeq (\$(COMPILER),)
\$(error \$(COMPILER) not found. Please install it and try again)
endif

ifdef CCACHE
CC = \$(CCACHE) \$(COMPILER)
else
CC = \$(COMPILER)
endif

SRC := src
INCLUDE := include

INC = -I \$(INCLUDE)

include flags.mk

OBJDIR := obj
BINDIR := bin

TARGET = \$(BINDIR)/\$(notdir \$(basename $project_name))

SOURCES = \$(wildcard \$(SRC)/*.$file_extension)
TMPOBJ = \$(patsubst %.$file_extension, %.o, \$(notdir \$(SOURCES)))
OBJECTS = \$(addprefix \$(OBJDIR)/, \$(TMPOBJ))

CPUS ?= \$(shell nproc)
ifdef CPUS
MAKEFLAGS += --jobs=\$(CPUS)
endif

all: \$(TARGET)

\$(TARGET): \$(OBJECTS)
	\$(CC) -o \$@ \$(OBJECTS) \$(LDFLAGS)

build:
	@mkdir -p \$(OBJDIR) \$(BINDIR)

\$(OBJECTS): \$(OBJDIR)/%.o: \$(SRC)/%.$file_extension
	\$(CC) \$(FLAGS) \$(INC) -c \$< -o \$@

debug: FLAGS += -g
debug:
	@echo "make \$(MAKEFLAGS) got executed in debug mode..."
debug: full

release: FLAGS += -O2
release: LDFLAGS += -s
release: full

full: clean build all

.PHONY: clean build all

clean:
	@echo "Cleaning target and object files..."

ifneq ("\$(wildcard \$(OBJECTS))", "")
	@rm \$(OBJECTS)
endif

ifeq ("\$(wildcard \$(OBJDIR))", "obj")
	@rmdir \$(OBJDIR)
endif

ifneq ("\$(wildcard \$(TARGET))", "")
	@rm \$(TARGET)
endif

ifeq ("\$(wildcard \$(BINDIR))", "bin")
	@rmdir \$(BINDIR)
endif

	@find . -type f -iname "*.gch" -delete

	@echo "All clear!"

.DEFAULT_GOAL := release
EOF
	fi
}

version() {
	cat <<EOF
mproj, version $version
Copyright (C) 2016 - $(date +'%Y') Stefanos Sofroniou
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
}

guidance() {
    cat <<EOF
    Usage: $(basename "$0") [OPTIONS] <project-name>

       -h, --help: It prints this help message and exit.

                c: It generates a C project with C11 flag.

              cpp: It generates a C++ project with C++17 flag.

    -v, --version: Displays project version and License.

EOF
}

skeleton() {
    if [ ! -d src ] && [ ! -d include ]
    then
        mkdir src include
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c11" ]
    then
        if [ ! -f src/main.c ]
        then
            touch src/main.c
            cat "$location/samples/c.txt" > src/main.c
        fi
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++17" ]
    then
        if [ ! -f src/main.cpp ]
        then
            touch src/main.cpp
            cat "$location/samples/cpp.txt" > src/main.cpp
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

        c )
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

        cpp )
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

