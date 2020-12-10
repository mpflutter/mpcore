part of '../mpcore.dart';

MPElement _encodeFlex(Element element) {
  final widget = element.widget as Flex;
  return MPElement(
    name: 'flex',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'direction': widget.direction.toString(),
      'mainAxisAlignment': widget.mainAxisAlignment.toString(),
      'mainAxisSize': widget.mainAxisSize.toString(),
      'crossAxisAlignment': widget.crossAxisAlignment.toString(),
    },
  );
}
