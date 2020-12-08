part of '../mpcore.dart';

_Element _encodeSizedBox(Element element) {
  final widget = element.widget as SizedBox;
  return _Element(
    name: 'sized_box',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'width': widget.width.toString(),
      'height': widget.height.toString(),
    },
  );
}
