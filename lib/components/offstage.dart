part of '../mpcore.dart';

MPElement _encodeOffstage(Element element) {
  final widget = element.widget as Offstage;
  return MPElement(
    name: 'offstage',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'offstage': widget.offstage,
    },
  );
}

MPElement _encodeSliverOffstage(Element element) {
  final widget = element.widget as SliverOffstage;
  return MPElement(
    name: 'offstage',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'offstage': widget.offstage,
    },
  );
}
