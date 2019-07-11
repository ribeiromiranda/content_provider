import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_plugin');

  static Future<List<Map<dynamic, dynamic>>> getContentValue(String uri) async {
    var parameters = {'uri': '$uri'};
    List<dynamic> data =
        await _channel.invokeMethod('getContent', Map.from(parameters));
    return data.cast<Map<dynamic, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> insertContentValue(
      String uri, dynamic data) async {
    final Map<String, dynamic> contentValues = Map();
    contentValues.putIfAbsent("contentValues", () => data);
    await _channel.invokeMethod('insertContent', [uri, contentValues]);
    return data;
  }

  static Future<List<Map<String, dynamic>>> updateContentValue(
      String uri, dynamic data, String where, List<String> whereArgs) async {
    final Map<String, dynamic> contentValues = Map();
    contentValues.putIfAbsent("contentValues", () => data);
    await _channel
        .invokeMethod('updateContent', [uri, contentValues, where, whereArgs]);
    return data;
  }

  static Future<List<Map<String, dynamic>>> deleteContentValue(String uri,
      dynamic data, String where, List<String> selectionArgs) async {
    await _channel.invokeMethod('deleteContent', [uri, where, selectionArgs]);
    return data;
  }
}
