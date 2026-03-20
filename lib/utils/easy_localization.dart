import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class RemoteAssetLoader extends AssetLoader {
  final String baseUrl;

  RemoteAssetLoader({required this.baseUrl});

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    try {
      // Gọi API lấy file dịch
      final response =
          await http.get(Uri.parse("$baseUrl/${locale.languageCode}.json"));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception("Failed to load translation from server");
      }
    } catch (e) {
      print("⚠️ Error loading remote translation: $e");

      // fallback: dùng file local
      final data =
          await rootBundle.loadString('$path/${locale.languageCode}.json');
      return json.decode(data);
    }
  }
}
