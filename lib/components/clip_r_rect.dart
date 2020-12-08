part of '../mpcore.dart';

_Element _encodeClipRRect(Element element) {
  final widget = element.widget as ClipRRect;
  return _Element(
    name: 'clip_r_rect',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'borderRadius': widget.borderRadius.toString(),
    },
  );
}

_Element _encodeClipRect(Element element) {
  return _Element(
    name: 'clip_r_rect',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'borderRadius': "",
    },
  );
}
