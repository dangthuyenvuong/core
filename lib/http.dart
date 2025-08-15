import 'dart:io';

import 'package:core/controllers/auth.controller.dart';
import 'package:core/log.dart';
import 'package:http/http.dart' as http;
// import 'package:mads/src/controllers/auth.controller.dart';
import 'dart:convert';

import 'package:get/get.dart';

class Http {
  static String _baseUrl = 'http://localhost:8080/api/v1';

  static setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static _getHeaders(Map<String, String>? headers) {
    final authController = Get.find<AuthController>();
    final token = authController.token?.accessToken;
    return {
      ...headers ?? {},
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
  }

  static throwError(http.Response response) {
    if (response.statusCode >= 400) {
      final json = jsonDecode(response.body);

      print('URL: ${response.request?.url}\nERROR: ${json}');
      throw ErrorHttpException(
          response: response, message: json['message'] as String?);
    }
  }

  static Future multipart(
      {required String url,
      required String method,
      Map<String, String>? headers,
      required Map<String, File> files}) async {
    final request =
        await http.MultipartRequest(method, getUrl(url));

    for (var file in files.entries) {
      request.files
          .add(await http.MultipartFile.fromPath(file.key, file.value.path));
    }

    request.headers.addAll(_getHeaders(headers));

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    // var json = jsonDecode(responseBody);
    print(responseBody);
    if (response.statusCode == 413) {
      throw 'File size too large';
    }

    return jsonDecode(responseBody);
    // if (response.statusCode == 200) {
    //   print('Upload Success');
    //   return json;
    // } else {
    //   print('Upload failed');
    // }
  }

  static Future get(String url,
      {Map<String, String>? headers,
      Object? body,
      Map<String, String>? queries}) async {
    if (queries != null) {
      url += '?${queries.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    }
    print('GET: $url');
    final response = await http.get(getUrl(url),
        headers: _getHeaders(headers));
    throwError(response);

    var value = jsonDecode(response.body);
    return value;
  }

  static Future post(String url,
      {Map<String, String>? headers, Object? body}) async {
    print('POST: $url');

    final response = await http.post(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);
    var value = jsonDecode(response.body);
    return value;
  }

  static Future patch(String url,
      {Map<String, String>? headers, Object? body}) async {
    print('PATCH: $url');

    final response = await http.patch(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);

    var value = jsonDecode(response.body);

    return value;
  }

  static Future put(String url,
      {Map<String, String>? headers, Object? body}) async {
    print('PUT: $url');
    final response = await http.put(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);

    var value = jsonDecode(response.body);

    return value;
  }

  static Future delete(String url,
      {Map<String, String>? headers, Object? body}) async {
    print('DELETE: $url');
    final response = await http.delete(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);
    var value = jsonDecode(response.body);

    return value;
  }

  static Uri getUrl(String url) {
    if (url.startsWith('http')) {
      return Uri.parse(url);
    }
    return Uri.parse(_baseUrl + url);
  }
}

class ErrorHttpException {
  final http.Response? response;
  final String? message;
  ErrorHttpException({this.response, this.message});
}
