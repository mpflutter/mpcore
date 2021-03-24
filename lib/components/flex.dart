part of '../mpcore.dart';

MPElement _encodeFlex(Element element) {
  final widget = element.widget as Flex;
  return MPElement(
    hashCode: element.hashCode,
    name: 'flex',
    children: MPElement.childrenFromFlutterElement(element),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'direction': widget.direction.toString(),
      'mainAxisAlignment': widget.mainAxisAlignment.toString(),
      'mainAxisSize': widget.mainAxisSize.toString(),
      'crossAxisAlignment': widget.crossAxisAlignment.toString(),
    },
  );
}
