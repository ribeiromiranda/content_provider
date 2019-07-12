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

  static Future<void> insertContentValue(
      String uri, dynamic data) async {
    var parameters = {'uri': '$uri'};
    final Map<String, dynamic> contentValues = Map();
    contentValues.putIfAbsent("contentValues", () => data);
   await _channel.invokeMethod(
        'insertContent', [Map.from(parameters), Map.from(contentValues)]);
  }

  static Future<void> updateContentValue(
      String uri, dynamic data, String where, List<String> whereArgs) async {
    var parameters = {'uri': '$uri'};
    var whereParam = {'where': '$where'};

    final Map<String, dynamic> contentValues = Map();
    contentValues.putIfAbsent("contentValues", () => data);
    final Map<String, dynamic> whereArg = Map();
    whereArg.putIfAbsent("whereArgs", () => whereArgs);
    await _channel.invokeMethod('updateContent',
        [Map.from(parameters), contentValues, Map.from(whereParam), whereArg]);
  }

  static Future<void> deleteContentValue(String uri,
      dynamic data, String where, List<String> selectionArgs) async {
    var parameters = {'uri': '$uri'};
    var whereParam = {'where': '$where'};
    final Map<String, dynamic> selectionArg = Map();
    selectionArg.putIfAbsent("whereArgs", () => selectionArgs);
    await _channel.invokeMethod('deleteContent', [Map.from(parameters), Map.from(whereParam), selectionArg]);
  }
}
