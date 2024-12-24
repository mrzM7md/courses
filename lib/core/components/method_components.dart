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
