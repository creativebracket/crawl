import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

void init(List<String> args) async {
  final parser = ArgParser();

  final command = parser.addCommand('init')
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Displays the help information.',
      negatable: false,
    );

  final results = command.parse(args);

  if (results.wasParsed('help')) {
    print('''
${blue("crawl: manage pubspec.yaml files and it's dependencies.")}

${command.usage}
    ''');
    return;
  }

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
  ''');
}
