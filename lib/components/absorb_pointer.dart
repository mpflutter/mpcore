part of '../mpcore.dart';

MPElement _encodeAbsorbPointer(Element element) {
  final widget = element.widget as AbsorbPointer;
  return MPElement(
    hashCode: element.hashCode,
    name: 'absorb_pointer',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {'absorbing': widget.absorbing},
  );
}
