part of '../mpcore.dart';

_Element _encodeFlex(Element element) {
  final widget = element.widget as Flex;
  return _Element(
    name: 'flex',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'direction': widget.direction.toString(),
      'mainAxisAlignment': widget.mainAxisAlignment.toString(),
      'mainAxisSize': widget.mainAxisSize.toString(),
      'crossAxisAlignment': widget.crossAxisAlignment.toString(),
    },
  );
}
