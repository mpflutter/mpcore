import 'dart:collection';
import 'dart:js' as js;

class JsMap with MapMixin<String, dynamic> {
  final js.JsObject obj;

  JsMap(this.obj);

  @override
  dynamic operator [](Object key) {
    return obj[key];
  }

  @override
  void operator []=(String key, value) {
    obj[key] = value;
  }

  @override
  void clear() {}

  @override
  Iterable<String> get keys =>
      ((js.context['Object'] as js.JsFunction).callMethod('keys', [obj])
              as js.JsArray)
          .toList()
          .cast<String>();

  @override
  dynamic remove(Object key) {}
}
