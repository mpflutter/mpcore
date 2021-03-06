part of '../mpcore.dart';

MPElement _encodeGestureDetector(Element element) {
  MPCore.addElementToHashCodeCache(element);
  final widget = element.widget as GestureDetector;
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'gesture_detector',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'onTap': widget.onTap != null ? element.hashCode : null,
    },
  );
}
