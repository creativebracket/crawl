import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;

class SearchCommand extends Command {
  @override
  String get description => 'search for package';

  @override
  String get name => 'search';

  @override
  String get invocation => 'crawl search <package>';

  @override
  void run() {
    searchPackage(argResults.arguments.first);
  }

  void searchPackage(String name) async {
    final response = await http.get('https://pub.dev/api/search?q=$name');
    final data = json.decode(response.body);
    final packages = data['packages'];

    print(Format.row([white('Name'), white('Current version')],
        widths: [40, -1]));

    // Query package version for each package
    final packageList = Stream.fromIterable(packages);
    await for (var info in packageList) {
      final details =
          await http.get('https://pub.dev/api/packages/${info['package']}');
      final version = json.decode(details.body)['latest']['version'];
      print(Format.row([info['package'], version], widths: [29, -1]));
    }
    print(white('Done ✅'));
  }
}
