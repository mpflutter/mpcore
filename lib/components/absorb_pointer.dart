part of '../mpcore.dart';

_Element _encodeAbsorbPointer(Element element) {
  final widget = element.widget as AbsorbPointer;
  return _Element(
    name: 'absorb_pointer',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {'absorbing': widget.absorbing},
  );
}
