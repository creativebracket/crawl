import 'package:args/command_runner.dart';
import 'package:crawl/src/commands/init.dart';
import 'package:test/test.dart';

void main() {
  group('init.dart', () {
    InitCommand cmd;
    CommandRunner runner;

    setUp(() {
      cmd = InitCommand();
      runner = CommandRunner(
        'crawl',
        "manage pubspec.yaml files and it's dependencies.",
      )..addCommand(cmd);
    });

    test('it should return the correct name', () {
      expect(cmd.name, equals('init'));
    });

    test('it should return the correct description', () {
      expect(cmd.description, equals('create a pubspec.yaml file'));
    });

    // TODO Write more tests
  });
}
