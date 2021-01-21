import 'package:flutter/foundation.dart';

enum TaroHttpResponseType {
  text,
  arraybuffer,
  json,
}

class TaroHttpRequest {
  final String url;
  final dynamic body;
  final Map headers;
  final String method;
  final TaroHttpResponseType responseType;

  TaroHttpRequest({
    @required this.url,
    this.body,
    this.headers = const {},
    this.method = 'GET',
    this.responseType = TaroHttpResponseType.text,
  });
}

class TaroHttpResponse<T> {
  final T data;
  final int statusCode;
  final Map headers;

  TaroHttpResponse({this.data, this.statusCode, this.headers});
}

abstract class TaroNetwork {
  static Future<TaroHttpResponse<T>> request<T>(TaroHttpRequest request) {
    return null;
  }
}
