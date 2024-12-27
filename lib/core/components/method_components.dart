import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:async';

Future<Uint8List?> getFileBytes(html.File file) async {
  final reader = html.FileReader();
  final completer = Completer<Uint8List?>();

  reader.onLoadEnd.listen((_) {
    completer.complete(reader.result as Uint8List?);
  });
  reader.readAsArrayBuffer(file);

  return completer.future;
}



String? urlValidation(String value) {
  // Regular expression for URL validation
  const String urlPattern = r'^(http|https):\/\/([A-Za-z0-9\.-]+)\.([A-Za-z]{2,6})([\/\w \.-]*)*\/?$';
  final regExp = RegExp(urlPattern);

  if (!regExp.hasMatch(value)) {
    return 'عنوان url غير صالح';
  }

  return null;
}