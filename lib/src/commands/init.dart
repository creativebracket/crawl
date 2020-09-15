import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

class InitCommand extends Command {
  @override
  String get description => 'create a pubspec.yaml file';

  @override
  String get name => 'init';

  @override
  void run() {
    if (argResults.wasParsed('help')) {
      print('''
${blue("crawl: manage pubspec.yaml files and it's dependencies.")}

${argParser.usage}
      ''');
    } else {
      runSteps();
    }
  }

  void runSteps() {
    print(cyan('''

.....####...#####....####...##...##..##........
....##..##..##..##..##..##..##...##..##........
....##......#####...######..##.#.##..##........
....##..##..##..##..##..##..#######..##........
.....####...##..##..##..##...##.##...######....
...............................................
'''));

    print('''
This utility will walk you through creating a pubspec.yaml file.
It only covers the most common items, and tries to guess sensible defaults.

See `crawl help init` for definitive documentation on these fields
and exactly what they do.

Press ^C at any time to quit.
  ''');

    final buffer = StringBuffer();

    // name
    final currentDirectory = Directory.current.path.split('/').last;
    final name = ask('package name:', defaultValue: currentDirectory);

    buffer.writeln('name: $name');

    // version
    final defaultVersion = '1.0.0';
    final version = ask('version:', defaultValue: defaultVersion);

    buffer.writeln('version: $version');

    // description, homepage, git repo
    const fields = [
      {'key': 'description', 'label': 'description:'},
      {'key': 'homepage', 'label': 'homepage url:'},
      {'key': 'repository', 'label': 'git repository url:'},
    ];

    for (var field in fields) {
      final answer = ask(field['label']);
      if (answer.isNotEmpty) {
        buffer.writeln('${field['key']}: $answer');
      }
    }

    // environment
    buffer.writeln('\nenvironment:');
    buffer.writeln("  sdk: '>=2.8.1 <3.0.0'");

    print('About to write to $pwd/pubspec.yaml:');

    print('\n${blue(buffer.toString())}');

    if (confirm('Is this OK?')) {
      'pubspec.yaml'.write(buffer.toString());
    } else {
      print('Aborted.');
    }
  }
}
