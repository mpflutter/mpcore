part of '../mpcore.dart';

MPElement _encodeAlign(Element element) {
  final widget = element.widget as Align;
  return MPElement(
    name: 'align',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {'alignment': widget.alignment.toString()},
  );
}
