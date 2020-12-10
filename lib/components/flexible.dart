part of '../mpcore.dart';

MPElement _encodeFlexible(Element element) {
  final widget = element.widget as Flexible;
  return MPElement(
    name: 'flexible',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'flex': widget.flex,
      'fit': widget.fit.toString(),
    },
  );
}
