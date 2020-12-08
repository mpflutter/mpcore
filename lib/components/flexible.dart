part of '../mpcore.dart';

_Element _encodeFlexible(Element element) {
  final widget = element.widget as Flexible;
  return _Element(
    name: 'flexible',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'flex': widget.flex,
      'fit': widget.fit.toString(),
    },
  );
}
