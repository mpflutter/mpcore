part of '../mpcore.dart';

Map<int, Element> gestureDetectorHandlers = {};

MPElement _encodeGestureDetector(Element element) {
  final widget = element.widget as GestureDetector;
  gestureDetectorHandlers[element.hashCode] = element;
  return MPElement(
    name: 'gesture_detector',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'onTap': widget.onTap != null ? element.hashCode : null,
    },
  );
}
