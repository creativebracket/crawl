import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

class UnusedCommand extends Command {
  @override
  String get description => 'list unused dependencies';

  @override
  String get name => 'unused';

  @override
  String get invocation => 'crawl unused';

  UnusedCommand() {
    argParser
      ..addOption('dir',
          abbr: 'd', help: 'Set directory to search', defaultsTo: './lib');
  }

  @override
  void run() => listUnusedPackages();

  void listUnusedPackages() async {
    final current = PubSpec.fromFile('pubspec.yaml');

    print(
      'Checking pubspec.yaml for packages that\n'
      "aren't referenced in import statements...",
    );

    print('\ndependencies:');
    printUnusedPackages(current.pubspec.dependencies);

    print('\ndependency_overrides:');
    printUnusedPackages(current.pubspec.dependencyOverrides);

    print('\ndev_dependencies:');
    printUnusedPackages(current.pubspec.devDependencies);
  }

  void printUnusedPackages(Map packages) {
    if (packages.isEmpty) {
      print('  No packages found.');
      return null;
    }

    // Check package is used in project
    for (var name in packages.keys) {
      final isUsingPackage = isUsedInProject(name);
      if (!isUsingPackage) {
        print(orange('  $name'));
      }
    }
  }

  bool isUsedInProject(String name) {
    try {
      final directory = argResults['dir'];
      'grep -Ril "import \'package:$name" $directory'.forEach((line) {});
      return true;
    } catch (e) {
      return false;
    }
  }
}
