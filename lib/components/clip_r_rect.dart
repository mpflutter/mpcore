part of '../mpcore.dart';

MPElement _encodeClipRRect(Element element) {
  final widget = element.widget as ClipRRect;
  return MPElement(
    hashCode: element.hashCode,
    name: 'clip_r_rect',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'borderRadius': widget.borderRadius.toString(),
    },
  );
}

MPElement _encodeClipRect(Element element) {
  return MPElement(
    hashCode: element.hashCode,
    name: 'clip_r_rect',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'borderRadius': '',
    },
  );
}
