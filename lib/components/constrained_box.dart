part of '../mpcore.dart';

_Element _encodeConstrainedBox(Element element) {
  final widget = element.widget as ConstrainedBox;
  return _Element(
    name: 'constrained_box',
    children: _Element.childrenFromFlutterElement(element),
    attributes: {
      'minWidth': widget.constraints.minWidth.toString(),
      'minHeight': widget.constraints.minHeight.toString(),
      'maxWidth': widget.constraints.maxWidth.toString(),
      'maxHeight': widget.constraints.maxHeight.toString(),
      'isTight': widget.constraints.isTight,
      'scrollable': MPCore.findTarget<Scrollable>(element) != null,
    },
  );
}
