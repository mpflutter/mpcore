part of '../mpcore.dart';

Map<int, Element> gestureDetectorHandlers = {};

_Element _encodeGestureDetector(Element element) {
  final widget = element.widget as GestureDetector;
  gestureDetectorHandlers[element.hashCode] = element;
  return _Element(
    name: 'gesture_detector',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'onTap': widget.onTap != null ? element.hashCode : null,
    },
  );
}
