import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:vintage_home/global.dart';

class ApiConsumer {
  Future<Uint8List> removeImageBackgroundApi (String imagePath) async {
    var requestApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.remove.bg/v1.0/removebg")
    );

    requestApi.files.add(
      await http.MultipartFile.fromPath(
        "image_file",
        imagePath
      )
    );

    requestApi.headers.addAll({
      "X-API-Key" : apiKeyRemoveImagebackground
    });

    final responseFromApi = await requestApi.send();

    if(responseFromApi.statusCode == 200) {
      http.Response getTransparentImageFromResponse = await http.Response.fromStream(responseFromApi);
      return getTransparentImageFromResponse.bodyBytes;
    }
    else {
      throw Exception("Erro Occured: " + responseFromApi.statusCode.toString());
    }
  }
}