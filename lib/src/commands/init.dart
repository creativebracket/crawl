import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:pubspec/pubspec.dart' show YamlToString;

class InitCommand extends Command {
  @override
  String get description => 'create a pubspec.yaml file';

  @override
  String get name => 'init';

  @override
  FutureOr<void> run() {
    runSteps();
  }

  static const fileOutput = 'pubspec.yaml';

  @override
  void printUsage() => print('''
$description

${argParser.usage}
''');

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

    final pubspecJson = {};

    // name
    final currentDirectory = Directory.current.path.split('/').last;
    final name = ask('package name:', defaultValue: currentDirectory);
    pubspecJson['name'] = name;

    // version
    final defaultVersion = '1.0.0';
    final version = ask('version:', defaultValue: defaultVersion);
    pubspecJson['version'] = version;

    // description, homepage, git repo
    const fields = [
      {'key': 'description', 'label': 'description:'},
      {'key': 'homepage', 'label': 'homepage url:'},
      {'key': 'repository', 'label': 'git repository url:'},
    ];

    for (var field in fields) {
      final answer = ask(field['label']);
      if (answer.isNotEmpty) {
        pubspecJson[field['key']] = answer;
      }
    }

    // environment
    final defaultEnv = '>=2.8.1 <3.0.0';
    final sdk = ask('environment sdk:', defaultValue: defaultEnv);
    pubspecJson['environment'] = {'sdk': sdk};

    print('About to write to $pwd/$fileOutput:');

    final yaml = YamlToString().toYamlString(pubspecJson);

    print('\n${blue(yaml)}');

    if (confirm('Is this OK?')) {
      final current = PubSpec.fromString(yaml);
      var output = fileOutput;

      if (exists(fileOutput)) {
        final confirmOverwrite =
            confirm(orange('Overwrite current pubspec.yaml file?'));

        if (confirmOverwrite) {
          current.saveToFile('');
        } else {
          output = '_$fileOutput';
          output.write(yaml);
        }
      }

      print(green('Successfully created $output.'));
    } else {
      print('Aborted.');
    }
  }
}
