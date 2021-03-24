part of '../mpcore.dart';

MPElement _encodeDivBox(Element element) {
  final children = MPElement.childrenFromFlutterElement(element);
  return MPElement(
    hashCode: element.hashCode,
    name: 'div',
    children: children,
    attributes: {},
  );
}
