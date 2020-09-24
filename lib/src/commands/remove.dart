import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

class RemoveCommand extends Command {
  @override
  String get description => 'removes a package';

  @override
  String get name => 'remove';

  @override
  String get invocation => 'crawl remove <package>';

  @override
  void run() {
    removePackage(argResults.arguments.first);
  }

  void removePackage(String name) async {
    final current = PubSpec.fromFile('pubspec.yaml');

    current.pubspec.dependencies.removeWhere((key, value) => key == name);
    current.pubspec.devDependencies.removeWhere((key, value) => key == name);

    current.saveToFile('.');

    // Update dependencies
    final isFlutter = current.pubspec.dependencies.containsKey('flutter');
    (isFlutter ? 'flutter pub get' : 'pub get').run;

    print(blue('Removed $name'));
  }
}
