import 'dart:io';
import 'package:path_provider/path_provider.dart';

Directory cookie;
void initCookieDirectory() async{
  Directory _appDocDirectory = await getApplicationDocumentsDirectory();

  new Directory(_appDocDirectory.path+'/'+'cookie').create(recursive: true)
      .then((Directory directory) {
    cookie = directory;
  });
}