part of '../mpcore.dart';

MPElement _encodeDivBox(Element element) {
  final children = MPElement.childrenFromFlutterElement(element);
  if (children.length == 1) {
    return children.first;
  } else {
    return MPElement(
      name: 'div',
      children: MPElement.childrenFromFlutterElement(element),
    );
  }
}
