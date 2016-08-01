#!/bin/bash

version="1.0.0"

std_flag=
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
    Usage: $(basename $0) [OPTIONS] <project-name>

    -h, --help:

        It prints this help message and exit.

    --c89:

        It generates a C project with C89 flag.

    --c99:

        It generates a C project with C99 flag.

    --c11:

        It generates a C project with C11 flag.

    --c++98:

        It generates a C++ project with C++98 flag.

    --c++11:

        It generates a C++ project with C++11 flag.

    --c++14:

        It generates a C++ project with C++14 flag.

    -v, --version:
    
        Displays project version and License.

EOF
    exit $1
}

skeleton()
{
    if [ ! -d src ] && [ ! -d include ]; then 
        mkdir {src,include}
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c89" ]; then

        touch src/main.c
        cat > src/main.c <<EOF
#include <stdio.h>

int main(void)
{
    printf("hello C89 world!\n");
    return 0;
}
EOF
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c99" ]; then

        touch src/main.c
        cat > src/main.c <<EOF
#include <stdio.h>

int main(void)
{
    for (int i = 0; i < 10; i++) {
        printf("i is %d\n", i);
    }
    
    printf("\nHello C99 world!\n");

    return 0;
}
EOF
    fi

    if [ $compiler = "gcc" ] && [ $std_flag = "c11" ]; then

        touch src/main.c
        cat > src/main.c <<EOF
#include <stdio.h>

#define typeOf(x)   \
    _Generic(       \
        (x),        \
        int: "int", \
    double: "double", \
    default: "none")

int main(void)
{
    printf("typeOf('A'): %s\n", typeOf('A'));
    printf("\nHello C11 World!\n");

    return 0;
}
EOF
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++98" ]; then
        
        touch src/main.cpp
        cat > src/main.cpp <<EOF
#include <iostream>

int main()
{
    std::cout << "Hello C++98 world!!!" << '\n';
    return 0;
}
EOF
    fi

    if [ $compiler = "g++" ] && [ $std_flag = "c++11" ]; then

        touch src/main.cpp
        cat > src/main.cpp <<EOF
#include <iostream>
#include <typeinfo>

int main()
{
    auto a = 1 + 2;
    std::cout << "type of a: " << typeid(a).name() << '\n';
    std::cout << "Hello C++11 world!" << '\n';
}
EOF
    fi
    if [ $compiler = "g++" ] && [ $std_flag = "c++14" ]; then 
        
        # special thanks to cppreference website for providing
        # this example.
        # I use it for demonstrative purposes and to check that
        # my actual flag mechanism works as expected.

        touch src/main.cpp
        cat > src/main.cpp <<EOF
#include <iostream>
#include <tuple>
#include <utility>
 
template<typename Func, typename Tup, std::size_t... index>
decltype(auto) 
invoke_helper(Func&& func, Tup&& tup, std::index_sequence<index...>)
{
    return func(std::get<index>(std::forward<Tup>(tup))...);
}
 
template<typename Func, typename Tup>
decltype(auto) 
invoke(Func&& func, Tup&& tup)
{
    constexpr auto Size = std::tuple_size<typename std::decay<Tup>::type>::value;
    return invoke_helper(std::forward<Func>(func),
                         std::forward<Tup>(tup),
                         std::make_index_sequence<Size>{});
}
 
void foo(int a, const std::string& b, float c)
{
    std::cout << a << " , " << b << " , " << c << '\n';
}
 
int main()
{
    auto args = std::make_tuple(2, "Hello", 3.5);
    invoke(foo, args);
    std::cout << "Hello C++14 world!" << '\n';
}
EOF
    fi
}

if [ $# -eq 0 ]; then
    echo
    echo "Illegal number of arguments. Add -h or --help flags for assistance."
    echo
fi

while [ $1 ]; do
    case $1 in
        --c89 )
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

            mkdir -p $project_name
            cd $project_name

            skeleton
            mk_template
            
            exit
            ;;

        --c99 )
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

            mkdir -p $project_name
            cd $project_name

            skeleton
            mk_template

            exit
            ;;

        --c11 )
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
            
            mkdir -p $project_name
            cd $project_name

            skeleton
            mk_template

            exit
            ;;

        --c++98 )
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

            mkdir -p $project_name
            cd $project_name

            skeleton
            mk_template

            exit
            ;;

        --c++11 )
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

            mkdir -p $project_name
            cd $project_name

            skeleton
            mk_template

            exit
            ;;

        --c++14 )
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

            mkdir -p $project_name
            cd $project_name

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

