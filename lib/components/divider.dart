part of '../mpcore.dart';

_Element _encodeDivider(Element element) {
  final widget = element.widget as Divider;
  return _Element(
    name: 'divider',
    attributes: {
      'height': (widget.height ?? 16.0).toString(),
      'thickness': (widget.thickness ?? 0.0).toString(),
      'color':
          (widget.color ?? Theme.of(element).dividerColor).value.toString(),
      'indent': (widget.indent ?? 0.0).toString(),
      'endIndent': (widget.endIndent ?? 0.0).toString(),
    },
  );
}