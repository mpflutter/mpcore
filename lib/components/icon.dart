part of '../mpcore.dart';

_Element _encodeIcon(Element element) {
  final widget = element.widget as Icon;
  return _Element(
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
