part of '../mpcore.dart';

MPElement _encodeGestureDetector(Element element) {
  final widget = element.widget as GestureDetector;
  return MPElement(
    hashCode: element.hashCode,
    name: 'gesture_detector',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'onTap': widget.onTap != null ? element.hashCode : null,
    },
  );
}
