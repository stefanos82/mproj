# mproj

Bash shell script that generates empty C or C++ project templates.

##About

**mproj** is a bash shell script that generates an empty C or C++ project
that consists of two directories, **src** and **include**, and a
**Makefile**.

It can generate the following versions:

* C language:
    - [x] C89
    - [x] C99
    - [x] C11
    
* C++ language:
   - [x] C++98
   - [x] C++11
   - [x] C++14

##Installation

You just run it as normal user.

##Uninstallation

Just delete the folder.

##CLI Usage

**mproj.sh** [FLAG] \<project-name\>

    In case you forget to insert a project name as your second argument,
    it defaults to [FLAG]_demo.

    Example(s):
        * mproj.sh --c89 /tmp/a/directory/of/your/choice
        * mproj.sh -c++11 

####FLAG

**-h, --help:**

    It prints this help message and exit.
    
**-c89, --c89**

    It generates a C project with C89 flag.

**-c99, --c99**

    It generates a C project with C99 flag.

**-c11, --c11**

    It generates a C project with C11 flag.

**-c++98, --c++98**

    It generates a C++ project with C++98 flag.

**-c++11, --c++11**

    It generates a C++ project with C++11 flag.

**-c++14, --c++14**

    It generates a C++ project with C++14 flag.

**-v, --version:**

    Displays project version and License.

##License

General Public License version 3.

##Disclaimer

This program comes with absolute no warranty.
You must use it at your own risk.
