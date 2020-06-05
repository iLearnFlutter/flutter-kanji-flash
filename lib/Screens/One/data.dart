import 'dart:convert';

import 'package:flutter/services.dart';

class KanjiData {
  final String radical;
  final HintData hint;
  KanjiData({this.radical, this.hint});
  KanjiData.fromJson(Map<String, dynamic> parsedJson)
      : radical = parsedJson['radical'],
        hint = HintData.fromJson(parsedJson['hint']);
}

class HintData {
  final String hanviet;
  final String kun;
  final String on;
  HintData(this.hanviet, this.kun, this.on);
  HintData.fromJson(Map<String, dynamic> parsedJson)
      : hanviet = parsedJson['hanviet'],
        kun = parsedJson['kun'],
        on = parsedJson['on'];
}

class DataListBuilder {
  static const String DEFAULT_KANJI_JSON_ASSET = "assets/kanji.json";
  static Future<String> _loadFromAsset() {
    return rootBundle.loadString(DEFAULT_KANJI_JSON_ASSET);
  }

  static Future<Iterable> _parseJson() async {
    String response = await _loadFromAsset();
    var jsonDecoded = jsonDecode(response);
    Iterable kanjiJsonList = jsonDecoded['kanjis'];
    return kanjiJsonList;
  }

  static Future<List<KanjiData>> build() async {
    Iterable iterable = await _parseJson();
    return List<dynamic>.of(iterable)
        .map((model) => KanjiData.fromJson(model))
        .toList();
  }
}
