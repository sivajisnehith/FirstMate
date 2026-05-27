import 'dart:async';
import 'mock_data.dart';

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchDuplicates(String repo) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: Replace with actual HTTP GET request to backend
    return MockData.duplicateIssues;
  }

  static Future<List<Map<String, dynamic>>> fetchPRStatus(String repo) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: Replace with actual HTTP GET request to backend
    return MockData.prStatuses;
  }

  static Future<String> generateReleaseNotes(String repo, String version) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: Replace with actual HTTP POST request to backend
    return '''
## Features
* **AI Duplicate Engine:** Improved detection accuracy by 15%.
* **Dark Mode Strategy:** Applied new sophisticated dark theme across all views.
* **PR Analytics:** Added new visualizations for stalled Pull Requests.

## Bug Fixes
* Fixed an issue where the sidebar would collapse incorrectly on smaller screens.
* Corrected color contrast ratios for accessibility in the active PR table.
* Prevented memory leak when rapidly switching between tabs.

## Contributors
* @flutter-dev-1
* @firstmate-bot
* @open-source-contributor
''';
  }
}
