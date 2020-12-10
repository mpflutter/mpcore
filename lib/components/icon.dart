part of '../mpcore.dart';

MPElement _encodeIcon(Element element) {
  final widget = element.widget as Icon;
  return MPElement(
    name: 'icon',
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
