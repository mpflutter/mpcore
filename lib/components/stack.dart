part of '../mpcore.dart';

_Element _encodeStack(Element element) {
  return _Element(
    name: 'stack',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {},
  );
}
