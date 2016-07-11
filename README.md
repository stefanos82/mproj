# mproj

Bash shell script that generates empty C or C++ project templates.

##About

**mproj** is a bash shell script that generates an empty C or C++ project
that consists of two directories, **src** and **include**, and a
**Makefile**.

It can generate the following versions:

* C language:
    * 89
    * C99
    * C11
    
* C++ language:
    * C++98
    * C++11
    * C++14
    * C++17

##Installation

You just run it as normal user.

##Uninstallation

Just delete the folder.

##CLI Usage

**mproj.sh** [FLAG] <project-name>

####FLAG
**-h, --help:**
    It prints this help message and exit.
    
**--c89**
    It generates a C project with C89 flag.

**--c99**
    It generates a C project with C99 flag.

**--c11**
    It generates a C project with C11 flag.

**c++98**
    It generates a C++ project with C++98 flag.

**c++11**
    It generates a C++ project with C++11 flag.

**c++14**
    It generates a C++ project with C++14 flag.

**c++17**
    It generates a C++ project with C++17 flag.

**-v, --version:**
    Displays project version and License.

##License

General Public License version 3.

##Disclaimer

This program comes with absolute no warranty.
You must use it at your own risk.

