part of '../mpcore.dart';

_Element _encodeAlign(Element element) {
  final widget = element.widget as Align;
  return _Element(
    name: 'align',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {'alignment': widget.alignment.toString()},
  );
}
