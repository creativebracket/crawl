Crawl helps you create pubspec files and manage it's packages.

## Installation

To use Crawl on the command line, install it using `pub global activate`:

```bash
$ pub global activate crawl
```

To update Crawl, use the same `pub global activate` command.

## Usage

A simple usage example:

```bash
$ mkdir nice_project
$ cd nice_project

$ crawl -h # print usage information
manage pubspec.yaml files and its dependencies.

Usage: crawl <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  init      create a pubspec.yaml file
  install   adds a new package
  remove    removes a package
  search    search for package
  unused    list unused dependencies

Run "crawl help <command>" for more information about a command.

$ crawl init # launch pubspec.yaml creation wizard
$ crawl install -p <pkg> # add a package to dependencies section
$ crawl install -p <pkg> -d # add a package to dev_dependencies section
$ crawl remove <pkg> # remove a package
$ crawl search <pkg> # search package
$ crawl unused # list unused packages in project. Searches `./lib` directory by default
$ crawl unused --dir=<directory> # list unused packages in provided directory
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/creativebracket/crawl/issues
