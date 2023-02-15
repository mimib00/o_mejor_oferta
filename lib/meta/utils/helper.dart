import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> validateImage(String path, String bucket) async {
  final dio = Dio();
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
