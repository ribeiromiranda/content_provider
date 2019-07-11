import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<Map<String, dynamic>>> getContentValue(Uri uri) async {
    final List<Map<String, dynamic>> data =
        await _channel.invokeMethod('getContent', [uri]);
    return data;
  }

  static Future<List<Map<String, dynamic>>> insertContentValue(
      Uri uri, dynamic data) async {
    final Map<String, dynamic> contentValues = Map();
    contentValues.putIfAbsent("contentValues", () => data);
    await _channel.invokeMethod('insertContent', [uri, contentValues]);
    return data;
  }

  static Future<List<Map<String, dynamic>>> updateContentValue(
      Uri uri, dynamic data, String where, List<String> whereArgs) async {
    final Map<String, dynamic> contentValues = Map();
    contentValues.putIfAbsent("contentValues", () => data);
    await _channel
        .invokeMethod('updateContent', [uri, contentValues, where, whereArgs]);
    return data;
  }

  static Future<List<Map<String, dynamic>>> deleteContentValue(
      Uri uri, dynamic data, String where, List<String> selectionArgs) async {
    await _channel
        .invokeMethod('deleteContent', [uri, where, selectionArgs]);
    return data;
  }
}
