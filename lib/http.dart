import 'dart:async';
import 'dart:io';

import 'package:core/log.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
// import 'package:mads/src/controllers/auth.controller.dart';
import 'dart:convert';

import 'package:get/get.dart';

class Http {
  static String _baseUrl = 'http://localhost:8080/api/v1';

  static String? token;

  static setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static String Function()? getToken;

  static _getHeaders(Map<String, String>? headers) {
    // final authController = Get.find<AuthController>();
    final _token = token ?? getToken?.call();
    Log.orange('Token: $_token', name: 'HTTP');

    return {
      ...headers ?? {},
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_token}',
    };
  }

  static throwError(http.Response response) {
    if (response.statusCode >= 400) {
      final json = jsonDecode(response.body);

      // print('URL: ${response.request?.url}\nERROR: ${json}');
      Log.red('URL: ${response.request?.url}\nERROR: ${json}', name: 'HTTP');
      throw ErrorHttpException(
          error_code: json['error_code'] as String?,
          response: response,
          message: json['message'] as String?);
    }
  }

  static Future multipart(
      {required String url,
      Map<String, dynamic>? body,
      required String method,
      Map<String, String>? headers,
      required Map<String, dynamic> files}) async {
    final request = await http.MultipartRequest(method, getUrl(url));

    for (var file in files.entries) {
      if (file.value is File) {
        request.files
            .add(await http.MultipartFile.fromPath(file.key, file.value.path));
      } else if (file.value is List<File>) {
        for (var f in file.value) {
          request.files
              .add(await http.MultipartFile.fromPath(file.key, f.path));
        }
      }
    }

    if (body != null) {
      request.fields.addAllRecursive(body);
    }

    request.headers.addAll(_getHeaders(headers));

    Log.green('Multipart: ${request.url}', name: 'HTTP');

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
      Map<String, dynamic>? queries}) async {
    // if (queries != null) {
    //   url += '?${queries.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    // }
    final _url = getUrl(url, queries: queries);
    Log.green('GET: $_url', name: 'HTTP');
    final response = await http.get(_url, headers: _getHeaders(headers));
    throwError(response);

    var value = jsonDecode(response.body);
    return value;
  }

  static Future post(String url,
      {Map<String, String>? headers, Object? body}) async {
    Log.green('POST: $url', name: 'HTTP');

    final response = await http.post(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);
    var value = jsonDecode(response.body);
    return value;
  }

  static Future<StreamClient> stream(
      {required String url,
      required Function(String) onData,
      required Function(dynamic) onError,
      Object? body,
      Map<String, dynamic>? queries,
      String? method}) async {
    final client = http.Client();
    final _url = getUrl(url, queries: queries);
    final request = http.Request(method ?? 'GET', _url);
    request.body = body != null ? jsonEncode(body) : "";
    request.headers.addAll(_getHeaders({}));
    request.headers['Accept'] = 'text/event-stream';
    Log.green('POST: $_url', name: 'HTTP');
    final response = await client.send(request);

    final subscription = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter()) // đọc theo dòng
        .listen((line) {
      if (line.startsWith("data: ")) {
        final data = line.replaceFirst("data: ", "");
        onData(data);
      }
    });

    subscription.onError((e) {
      throwError(e);
    });

    return StreamClient(client, subscription);
  }

  static Future patch(String url,
      {Map<String, String>? headers, Object? body}) async {
    Log.green('PATCH: $url', name: 'HTTP');

    final response = await http.patch(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);

    var value = jsonDecode(response.body);

    return value;
  }

  static Future put(String url,
      {Map<String, String>? headers, Object? body}) async {
    Log.green('PUT: $url', name: 'HTTP');

    final response = await http.put(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);

    var value = jsonDecode(response.body);

    return value;
  }

  static Future delete(String url,
      {Map<String, String>? headers, Object? body}) async {
    Log.green('DELETE: $url', name: 'HTTP');

    final response = await http.delete(getUrl(url),
        headers: _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null);

    throwError(response);
    var value = jsonDecode(response.body);

    return value;
  }

  static Uri getUrl(
    String url, {
    Map<String, dynamic>? queries,
  }) {
    final _queries = Map<String, dynamic>.from(queries ?? {})
      ..removeWhere((key, value) => value == null || value == '');

    final query = Uri(queryParameters: _queries).query;
    if (url.startsWith('http')) {
      return Uri.parse(url + (query.isNotEmpty ? '?$query' : ''));
    }
    return Uri.parse(_baseUrl + url + (query.isNotEmpty ? '?$query' : ''));

    // return Uri(
    //   scheme: 'http',
    //   host: _baseUrl,
    //   path: url,
    //   queryParameters: queries,
    // );
  }
}

class ErrorHttpException {
  final http.Response? response;
  final String? message;
  final String? error_code;
  ErrorHttpException({this.response, this.message, this.error_code});
}

class StreamClient {
  http.Client client;
  StreamSubscription<String> subscription;

  StreamClient(this.client, this.subscription);

  void close() {
    subscription.cancel();
    client.close();
  }
}
