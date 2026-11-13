// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Browser download implementation used only by Flutter Web.
Future<bool> downloadJson(String filename, String contents) async {
  final blob = html.Blob([contents], 'application/json;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
  return true;
}
