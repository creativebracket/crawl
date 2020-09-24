import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;
import 'package:pubspec/pubspec.dart' show HostedReference;

class InstallCommand extends Command {
  @override
  String get description => 'adds a new package';

  @override
  String get name => 'install';

  InstallCommand() {
    argParser
      ..addOption('package', abbr: 'p', help: 'Specify package to install')
      ..addOption('version', abbr: 'v', help: 'Set package version to install')
      ..addFlag('dev',
          abbr: 'd',
          help: 'Add package to dev_dependencies group',
          negatable: false);
  }

  @override
  void run() {
    if (!argResults.wasParsed('package')) {
      print(red('Please provide a package via the -p option.'));
      exit(1);
    }

    if (!exists('pubspec.yaml')) {
      print(red(
          'No pubspec.yaml file in project. Please create one with the `crawl init` command.'));
      exit(1);
    }

    installPackage(argResults['package']);
  }

  void installPackage(String name) async {
    final response = await http.get('https://pub.dev/api/packages/$name');
    final data = json.decode(response.body);

    // Exit if package not found
    if (response.statusCode == HttpStatus.notFound) {
      final code = data['error']['code'];
      final message = data['error']['message'];
      print(red('$code: $message'));
      exit(1);
    }

    final version = resolveVersion(data);
    final current = PubSpec.fromFile('pubspec.yaml');

    // Add entry to correct group
    final entry = {name: HostedReference.fromJson(version)};
    if (argResults.wasParsed('dev')) {
      current.pubspec.devDependencies.addAll(entry);
    } else {
      current.pubspec.dependencies.addAll(entry);
    }

    current.saveToFile('.');

    // Update dependencies
    final isFlutter = current.pubspec.dependencies.containsKey('flutter');
    (isFlutter ? 'flutter pub get' : 'pub get').run;

    print(green('Added $name $version'));
  }

  String resolveVersion(Map package) {
    if (argResults.wasParsed('version')) {
      final filteredRelease = package['versions']
          .where((release) => release['version'] == argResults['version'])
          .toList();

      if (filteredRelease.isNotEmpty) {
        return filteredRelease[0]['version'];
      }

      print(orange(
          'Package version ${argResults['version']} not found. Installing latest...'));
    }
    return '^${package['latest']['version']}';
  }
}
