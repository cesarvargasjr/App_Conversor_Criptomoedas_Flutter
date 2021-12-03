// To parse this JSON data, do
//
// final welcome = welcomeFromMap(jsonString);
// import 'package:meta/meta.dart';
// import 'dart:convert';

class ResultApi {
  late Ticker ticker;

  ResultApi.fromJson(Map<String, dynamic> json) {
    ticker = (json['ticker'] != null ? Ticker.fromJson(json['ticker']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data['ticker'] = ticker.toJson();
  }
}

class Ticker {
  late String buy;

  Ticker.fromJson(Map<String, dynamic> json) {
    buy = json['buy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['buy'] = buy;
    return data;
  }
}
