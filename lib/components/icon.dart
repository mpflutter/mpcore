part of '../mpcore.dart';

MPElement _encodeIcon(Element element) {
  final widget = element.widget as Icon;
  return MPElement(
    hashCode: element.hashCode,
    name: 'icon',
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'icon': {
        'fontFamily': widget.icon?.fontFamily,
        'codePoint': widget.icon?.codePoint,
      },
      'color': widget.color?.value?.toString(),
      'size': widget.size,
    },
  );
}
