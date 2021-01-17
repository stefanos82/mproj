# mproj

Bash shell script that generates empty C or C++ project templates.

## About

**mproj** is a bash shell script that generates an empty C or C++ project
that consists of two directories, **src** and **include**, and a
**Makefile**.

## Installation

You just run it as normal user, but I would suggest to add it in your PATH so 
you can access it from pretty much anywhere.

Personally I have a `bin` directory in $HOME and have symlink-ed `mproj`
in there.

## Uninstallation

First make sure you remove any symlink and then delete the folder
wherever is located.

## CLI Usage

```bash
    mproj [FLAG] <project-name>
```

In case you forget to insert a project name as your second argument,
it defaults to `[FLAG]_demo`.

Example(s):

```bash
    mproj c /tmp/a/directory/of/your/choice
    mproj c MyC11 (it defaults to C11)
    mproj cpp MyCPP17 (it defaults to C++17)
```

#### FLAGS

**-h, --help:**

    It prints this help message and exit.

**c:**

    It generates a C project with C11 flag.

**cpp:**

    It generates a C++ project with C++17 flag.

**-v, --version:**

    Displays project version and License.

## License

General Public License version 3.

## Disclaimer

This program comes with absolute no warranty.
You must use it at your own risk.
