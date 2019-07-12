import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:io';

class FlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_plugin');

  static Future<List<Map<dynamic, dynamic>>> getContentValue(String uri) async {
    var parameters = {'uri': '$uri'};
    if (!_isValidUri(uri)) {
      throw Exception("invalid data");
    }
    if (Platform.isIOS) {
      throw Exception("Not impleted for ios");
    }
    List<dynamic> data =
        await _channel.invokeMethod('getContent', Map.from(parameters));
    return data.cast<Map<dynamic, dynamic>>();
  }

  static Future<void> insertContentValue(String uri, dynamic data) async {
    var parameters = {'uri': '$uri'};
    if (!_isValidUri(uri) || data == null) {
      throw Exception("invalid data");
    }
    if (Platform.isIOS) {
      throw Exception("Not impleted for ios");
    }
    try {
      final Map<String, dynamic> contentValues = Map();
      contentValues.putIfAbsent("contentValues", () => data);
      await _channel.invokeMethod(
          'insertContent', [Map.from(parameters), Map.from(contentValues)]);
    } catch (exception) {}
  }

  static Future<void> updateContentValue(String uri, dynamic data,
      {String where, List<String> whereArgs}) async {
    var parameters = {'uri': '$uri'};
    var whereParam = {'where': '$where'};

    if (!_isValidUri(uri) || data == null) {
      throw Exception("invalid data");
    }
    if (where != null && where.isEmpty) {
      throw Exception("invalid data");
    }
    if (whereArgs != null && whereArgs.isEmpty) {
      throw Exception("invalid data");
    }
    if (Platform.isIOS) {
      throw Exception("Not impleted for ios");
    }
    try {
      final Map<String, dynamic> contentValues = Map();
      contentValues.putIfAbsent("contentValues", () => data);
      final Map<String, dynamic> whereArg = Map();
      whereArg.putIfAbsent("whereArgs", () => whereArgs);
      await _channel.invokeMethod('updateContent', [
        Map.from(parameters),
        contentValues,
        Map.from(whereParam),
        whereArg
      ]);
    } catch (exception) {}
  }

  static Future<void> deleteContentValue(String uri, dynamic data, String where,
      List<String> selectionArgs) async {
    if (!_isValidUri(uri) || data == null) {
      throw Exception("invalid data");
    }
    if (where != null && where.isEmpty) {
      throw Exception("invalid data");
    }
    if (selectionArgs != null && selectionArgs.isEmpty) {
      throw Exception("invalid data");
    }
    if (Platform.isIOS) {
      throw Exception("Not impleted for ios");
    }
    try {
      var parameters = {'uri': '$uri'};
      var whereParam = {'where': '$where'};
      final Map<String, dynamic> selectionArg = Map();
      selectionArg.putIfAbsent("whereArgs", () => selectionArgs);
      await _channel.invokeMethod('deleteContent',
          [Map.from(parameters), Map.from(whereParam), selectionArg]);
    } catch (exception) {}
  }

  static bool _isValidUri(String uri) => (uri != null && uri.isNotEmpty);
}
