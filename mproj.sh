#!/bin/bash

version="0.0.1"

user_flag=
project_name=
compiler=
file_extension=

mk_template()
{
    cat > Makefile <<EOF
CC = $compiler

SRC = src
INCLUDE = include

INC = -I \$(INCLUDE)

FLAGS += -Wall
FLAGS += -pedantic
FLAGS += -std=$user_flag
FLAGS += -O2

OBJDIR := obj
BINDIR := bin

TARGET = \$(BINDIR)/demo

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
}

version()
{
	cat <<EOF
	mproj, version $version
	Copyright (C) $(date +'%Y') Free Software Foundation, Inc.
	License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

	This is free software; you are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.
EOF
}

guidance()
{
    cat <<EOF
    Usage: $(basename $0) [OPTIONS]

    -h | --help:
        It prints this help message and exit.

    -v | --version:
        It displays project version and License.
EOF
    exit $1
}

skeleton()
{
    if [ ! -d src ] && [ ! -d include ]; then 
        mkdir {src,include}
    fi
    touch src/main.c
    
    cat > src/main.c <<EOF
#include <stdio.h>

int main(void)
{
    printf("hello C world!\n");
    return 0;
}
EOF
}

if [ $# -ne 2 ]; then
    echo
    echo "Illegal number of arguments. Add -h or --help flags for assistance."
    echo
fi

while [ $1 ]; do
    case $1 in
        --c89 )
            compiler=gcc
            file_extension=c
            user_flag=c89
            project_name=$2
            shift
            mkdir $project_name
            cd $project_name

            skeleton
            mk_template
            exit
            ;;

        --c99 )
            compiler=gcc
            file_extension=c
            user_flag=c99
            project_name=$2
            shift
            mkdir $project_name
            cd $project_name

            skeleton
            mk_template
            exit
            ;;

        --c11 )
            user_flag=c11
            skeleton
            exit
            ;;

        --c++98 )
            exit
            ;;

        --c++11 )
            exit
            ;;

        --c++14 )
            exit
            ;;
            
        --c++17 )
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

