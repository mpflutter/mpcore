part of '../mpcore.dart';

_Element _encodeOffstage(Element element) {
  final widget = element.widget as Offstage;
  return _Element(
    name: 'offstage',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'offstage': widget.offstage,
    },
  );
}

_Element _encodeSliverOffstage(Element element) {
  final widget = element.widget as SliverOffstage;
  return _Element(
    name: 'offstage',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'offstage': widget.offstage,
    },
  );
}
