part of '../mpcore.dart';

MPElement _encodeSliverPersistentHeader(Element element) {
  final widget = element.widget as SliverPersistentHeader;
  return MPElement(
    hashCode: element.hashCode,
    name: 'sliver_persistent_header',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'pinned': widget.pinned,
    },
  );
}
