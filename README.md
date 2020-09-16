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

$ crawl help # launch list of commands
$ crawl init # launch pubspec.yaml creation wizard
$ crawl install -p <pkg> # add a package to dependencies section
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/creativebracket/crawl/issues
