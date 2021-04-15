// ignore: library_prefixes
import 'dart:js' as dartJs;

import 'dart:math';

JsObject get context {
  return JsObject();
}

typedef OnCall = dynamic Function(List l);

class VarargsFunction implements Function {
  final OnCall _onCall;

  VarargsFunction(this._onCall);

  @override
  void noSuchMethod(Invocation invocation) {
    Function.apply(_onCall, invocation.positionalArguments);
  }
}

class JsObject {
  static Map<String, dartJs.JsObject> objectRefs = {};

  final List<String> _callChain = [];
  final String objectHandler;

  static dynamic wrapBrowserObject(dynamic obj) {
    if (obj is JsObject) {
      return obj;
    } else if (obj is String) {
      return obj;
    } else if (obj is num) {
      return obj;
    } else if (obj is dartJs.JsObject) {
      final objectHandler = Random().nextDouble().toString();
      objectRefs[objectHandler] = obj;
      return JsObject(objectHandler: objectHandler);
    } else {
      return JsObject();
    }
  }

  JsObject({this.objectHandler});

  JsObject operator [](Object property) {
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
    return getCallee().hasProperty(key);
  }

  Future<void> deleteProperty(String key) async {
    return getCallee().deleteProperty(key);
  }

  Future<dynamic> callMethod(Object method, [List args]) async {
    return getCallee().callMethod(method, args);
  }

  Future<dynamic> getPropertyValue(String key) async {
    return wrapResult(getCallee()[key]);
  }

  Future<dynamic> setPropertyValue(String key, dynamic value) async {
    getCallee()[key] = value;
  }

  dartJs.JsObject getCallee() {
    dynamic currentObject = objectHandler != null
        ? objectRefs[objectHandler] ?? dartJs.context
        : dartJs.context;
    for (var key in _callChain) {
      currentObject = currentObject[key];
      if (currentObject == null) {
        break;
      }
    }
    return currentObject as dartJs.JsObject;
  }

  dynamic wrapResult(dynamic result) {
    return wrapBrowserObject(result);
  }
}
