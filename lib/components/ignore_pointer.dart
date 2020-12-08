part of '../mpcore.dart';

_Element _encodeIgnorePointer(Element element) {
  final widget = element.widget as IgnorePointer;
  return _Element(
    name: 'ignore_pointer',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {'ignoring': widget.ignoring},
  );
}
