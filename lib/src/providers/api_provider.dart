import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class ApiProvider {
  static Future<void> subirArchivos({List<File> files}) async {
    try {
      final url = "http://127.0.0.1:3000/subirlista";
      var uri = Uri.parse(url);
      var request = new http.MultipartRequest("POST", uri);

      files.forEach((file) async {
        print(file.path.split('/').last);
        var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        request.files.add(new http.MultipartFile('files', stream, length,
            filename: basename(file.path)));
      });
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

      throw PlatformException(code: "500", message: "Error /subirlista");
    } on PlatformException catch (e) {
      return (e.message);
    }
  }

  static Future<void> subirArchivo({File file}) async {
    try {
      final url = "http://127.0.0.1:3000/subir";
      var uri = Uri.parse(url);
      var request = new http.MultipartRequest("POST", uri);
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      request.files.add(
        new http.MultipartFile(
          'file',
          stream,
          length,
          filename: basename(file.path),
        ),
      );
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      throw PlatformException(code: "500", message: "Error /subirlista");
    } on PlatformException catch (e) {
      return (e.message);
    }
  }
}
