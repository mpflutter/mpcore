part of '../mpcore.dart';

MPElement _encodeIgnorePointer(Element element) {
  final widget = element.widget as IgnorePointer;
  return MPElement(
    name: 'ignore_pointer',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {'ignoring': widget.ignoring},
  );
}
