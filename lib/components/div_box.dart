part of '../mpcore.dart';

_Element _encodeDivBox(Element element) {
  final children = _Element.childrenFromFlutterElement(element);
  if (children.length == 1) {
    return children.first;
  } else {
    return _Element(
      name: 'div',
      children: _Element.childrenFromFlutterElement(element),
    );
  }
}
