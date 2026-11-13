import 'json_export_stub.dart'
    if (dart.library.html) 'json_export_web.dart' as platform;

/// Downloads a JSON file on Flutter Web. Native platforms use the clipboard
/// fallback in the dashboard so no additional file-system plugin is required.
Future<bool> downloadJson(String filename, String contents) {
  return platform.downloadJson(filename, contents);
}
