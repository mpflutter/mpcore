part of '../mpcore.dart';

_Element _encodeCustomScrollView(Element element) {
  final viewportElement = MPCore.findTarget<Viewport>(element);
  if (viewportElement == null) {
    return _Element(
      name: 'custom_scroll_view',
      children: [],
    );
  }
  return _Element(
    name: 'custom_scroll_view',
    children: _Element.childrenFromFlutterElement(viewportElement),
  );
}
