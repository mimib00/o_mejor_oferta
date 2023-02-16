import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mejor_oferta/core/config.dart';

final dio = Dio();
Future<bool> validateImage(String path, String bucket) async {
  try {
    const url = 'https://us-central1-mejor-oferta-c88d1.cloudfunctions.net/detectOffensiveImages';
    final res = await dio.post(
      url,
      data: {
        'path': path,
        'bucket': bucket,
      },
    );

    return res.data;
  } on DioError catch (e) {
    Fluttertoast.showToast(msg: e.message);
  }
  return false;
}

Future<List<String>> getBadWordsList() async {
  try {
    const url = '$baseUrl/listings/forbidden-words/';
    final res = await dio.get(url);
    final List data = res.data;
    return data.map((e) => e['word'].toString().toLowerCase()).toList();
  } on DioError catch (e) {
    Fluttertoast.showToast(msg: e.message);
  }
  return [];
}
