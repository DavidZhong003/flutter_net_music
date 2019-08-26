import 'dart:io';
import 'package:path_provider/path_provider.dart';

Directory _cookie;

Future<Directory> getCookieDirectory() async {
  if (_cookie != null) {
    return _cookie;
  }
  Directory _appDocDirectory = await getApplicationDocumentsDirectory();

  _cookie = await Directory(_appDocDirectory.path + '/' + 'cookie')
      .create(recursive: true);
  return _cookie;
}
