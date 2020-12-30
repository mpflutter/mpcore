part of '../mpcore.dart';

MPElement _encodeWrap(Element element) {
  final widget = element.widget as Wrap;
  return MPElement(
    name: 'wrap',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'direction': widget.direction?.toString(),
      'alignment': widget.alignment?.toString(),
      'spacing': widget.spacing,
      'runAlignment': widget.runAlignment?.toString(),
      'runSpacing': widget.runSpacing,
      'crossAxisAlignment': widget.crossAxisAlignment?.toString(),
      'textDirection': widget.textDirection?.toString(),
      'verticalDirection': widget.verticalDirection?.toString(),
      'clipBehavior': widget.clipBehavior?.toString(),
    },
  );
}
