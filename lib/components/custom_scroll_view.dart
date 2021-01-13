part of '../mpcore.dart';

MPElement _encodeCustomScrollView(Element element) {
  final viewportElement = MPCore.findTarget<Viewport>(element);
  if (viewportElement == null) {
    return MPElement(
      name: 'custom_scroll_view',
      children: [],
      attributes: {},
    );
  }
  return MPElement(
    name: 'custom_scroll_view',
    children: MPElement.childrenFromFlutterElement(viewportElement),
    attributes: {},
  );
}
