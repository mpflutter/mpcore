import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../channel/channel_io.dart';

JsObject get context {
  return JsObject();
}

class JsBridgeInvoker {
  static final instance = JsBridgeInvoker();

  Map<String, Completer> handlers = {};

  Future makeRequest(String event, Map params) {
    final completer = Completer();
    final requestId = Random().nextDouble().toString();
    handlers[requestId] = completer;
    MPChannel.postMesssage(
      json.encode({
        'type': 'mpjs',
        'message': {
          'event': event,
          'requestId': requestId,
          'params': params,
        },
      }),
      forLastConnection: true,
    );
    return completer.future;
  }

  void makeResponse(Map message) {
    if (!(message is Map)) return;
    if (message['requestId'] != null) {
      final String requestId = message['requestId'];
      handlers[requestId]
          ?.complete(JsObject.wrapBrowserObject(message['result']));
      handlers.remove(requestId);
    } else if (message['funcId'] != null) {
      final String funcId = message['funcId'];
      final func =
          JsObject.funcHandlers[int.tryParse(funcId.replaceFirst('func:', ''))];
      if (func != null) {
        Function.apply(
          func,
          (message['arguments'] as List)
              .map((e) => JsObject.wrapBrowserObject(e))
              .toList(),
        );
      }
    }
  }
}

class JsObject {
  static Map<int, Function> funcHandlers = {};

  static dynamic wrapBrowserObject(dynamic obj) {
    if (obj is JsObject) {
      return obj;
    } else if (obj is String) {
      return obj;
    } else if (obj is num) {
      return obj;
    } else if (obj is Map && obj['objectHandler'] is String) {
      return JsObject(objectHandler: obj['objectHandler']);
    } else {
      return JsObject();
    }
  }

  static dynamic toBrowserObject(dynamic obj) {
    if (obj is Function) {
      final funcId = obj.hashCode;
      funcHandlers[funcId] = obj;
      return 'func:${funcId}';
    } else if (obj is JsObject) {
      return 'obj:${obj.objectHandler}';
    } else {
      return obj;
    }
  }

  final List<String> _callChain = [];
  final String? objectHandler;

  JsObject({this.objectHandler});

  JsObject operator [](Object property) {
    if (!(property is String)) return JsObject();
    return getProperty(property);
  }

  JsObject getProperty(String key) {
    final obj = JsObject();
    obj._callChain
      ..addAll(_callChain)
      ..add(key);
    return obj;
  }

  Future<bool> hasProperty(String key) async {
    final result = await JsBridgeInvoker.instance.makeRequest('hasProperty', {
      'callChain': _callChain,
      'objectHandler': objectHandler,
      'key': key,
    });
    if (result is bool) {
      return result;
    } else {
      return false;
    }
  }

  Future<void> deleteProperty(String key) {
    return JsBridgeInvoker.instance.makeRequest('deleteProperty', {
      'callChain': _callChain,
      'objectHandler': objectHandler,
      'key': key,
    });
  }

  Future<dynamic> callMethod(Object method, [List? args]) async {
    final result = await JsBridgeInvoker.instance.makeRequest('callMethod', {
      'objectHandler': objectHandler,
      'callChain': _callChain,
      'method': method,
      'args': args?.map((e) {
        return toBrowserObject(e);
      }).toList(),
    });
    return result;
  }

  Future<dynamic> getPropertyValue(String key) async {
    final result = await JsBridgeInvoker.instance.makeRequest('getValue', {
      'objectHandler': objectHandler,
      'callChain': _callChain,
      'key': key,
    });
    return result;
  }

  Future<dynamic> setPropertyValue(String key, dynamic value) async {
    final result = await JsBridgeInvoker.instance.makeRequest('setValue', {
      'objectHandler': objectHandler,
      'callChain': _callChain,
      'key': key,
      'value': toBrowserObject(value),
    });
    return result;
  }
}
