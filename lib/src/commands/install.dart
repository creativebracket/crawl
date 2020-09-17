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
      ..addOption('version', abbr: 'v', help: 'Set package version to install');
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

    var version = data['latest']['version'];
    final current = PubSpec.fromFile('pubspec.yaml');

    if (argResults.wasParsed('version')) {
      final specificVersion = (data['versions'] as List)
          .where((release) => release['version'] == argResults['version'])
          .toList();

      if (specificVersion.isNotEmpty) {
        version = specificVersion[0]['version'];
      } else {
        print(orange(
            'Package version ${argResults['version']} not found. Installing latest...'));
      }
    }

    // Add new dependency
    current.pubspec.dependencies
        .addAll({name: HostedReference.fromJson('^$version')});

    current.saveToFile('pubspec.yaml');

    // Update dependencies
    'pub get'.run;

    print(green('Installed $name ^$version'));
  }
}
