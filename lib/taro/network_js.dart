import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'package:mpcore/taro/js_map.dart';

import 'network_defines.dart' hide TaroNetwork;
export 'network_defines.dart' hide TaroNetwork;

class TaroNetwork {
  static Future<TaroHttpResponse<T>> request<T>(TaroHttpRequest request) {
    final completer = Completer<TaroHttpResponse<T>>();
    (js.context['Taro'] as js.JsObject).callMethod('request', [
      js.JsObject.jsify({
        'url': request.url,
        'method': request.method,
        'header': request.headers,
        'responseType': 'arraybuffer',
        'body': request.body,
        'success': (response) {
          if (response['statusCode'] >= 400) {
            completer.completeError(TaroHttpResponse(
              statusCode: response['statusCode'],
            ));
            return;
          }
          final dataList = base64.decode((js.context['Taro'] as js.JsObject)
              .callMethod('arrayBufferToBase64', [response['data']]) as String);
          completer.complete(
            TaroHttpResponse(
              data: (() {
                switch (request.responseType) {
                  case TaroHttpResponseType.arraybuffer:
                    return dataList as T;
                  case TaroHttpResponseType.json:
                    return json.decode(utf8.decode(dataList)) as T;
                  case TaroHttpResponseType.text:
                    return utf8.decode(dataList) as T;
                  default:
                    return utf8.decode(dataList) as T;
                }
              })(),
              headers: JsMap(response['header']),
              statusCode: response['statusCode'],
            ),
          );
        },
        'fail': (error) {
          completer.completeError(TaroHttpResponse(
            statusCode: error['statusCode'],
          ));
        },
      }),
    ]);
    return completer.future;
  }
}
