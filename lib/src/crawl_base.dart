import 'package:args/command_runner.dart';

import 'commands/init.dart';
import 'commands/install.dart';
import 'commands/remove.dart';
import 'commands/search.dart';
import 'commands/unused.dart';

/// Initialises the crawl runner and list of commands.
void start(List<String> args) {
  final runner = CommandRunner(
    'crawl',
    "manage pubspec.yaml files and it's dependencies.",
  )
    ..addCommand(InitCommand())
    ..addCommand(InstallCommand())
    ..addCommand(RemoveCommand())
    ..addCommand(SearchCommand())
    ..addCommand(UnusedCommand());
  runner.run(args);
}
