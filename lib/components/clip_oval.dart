part of '../mpcore.dart';

_Element _encodeClipOval(Element element) {
  // final widget = element.widget as ClipOval;
  return _Element(
    name: 'clip_oval',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {},
  );
}
