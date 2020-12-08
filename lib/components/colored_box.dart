part of '../mpcore.dart';

_Element _encodeColoredBox(Element element) {
  final widget = element.widget as ColoredBox;
  return _Element(
    name: 'colored_box',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {'color': widget.color.value.toString()},
  );
}
