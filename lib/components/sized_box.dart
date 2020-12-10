part of '../mpcore.dart';

MPElement _encodeSizedBox(Element element) {
  final widget = element.widget as SizedBox;
  return MPElement(
    name: 'sized_box',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'width': widget.width.toString(),
      'height': widget.height.toString(),
    },
  );
}
