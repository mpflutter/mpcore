part of '../mpcore.dart';

MPElement _encodeCustomScrollView(Element element) {
  final viewportElement = MPCore.findTarget<Viewport>(element);
  if (viewportElement == null) {
    return MPElement(
      name: 'custom_scroll_view',
      children: [],
      // ignore: invalid_use_of_protected_member
      constraints: element.findRenderObject()?.constraints,
      attributes: {},
    );
  }
  return MPElement(
    name: 'custom_scroll_view',
    children: MPElement.childrenFromFlutterElement(viewportElement),
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {},
  );
}
