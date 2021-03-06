part of '../mpcore.dart';

MPElement _encodeClipRRect(Element element) {
  final widget = element.widget as ClipRRect;
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'clip_r_rect',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'borderRadius': widget.borderRadius.toString(),
    },
  );
}

MPElement _encodeClipRect(Element element) {
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'clip_r_rect',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'borderRadius': '',
    },
  );
}
