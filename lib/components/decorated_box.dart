part of '../mpcore.dart';

MPElement _encodeDecoratedBox(Element element) {
  final widget = element.widget as DecoratedBox;
  final attributes = <String, dynamic>{};
  if (widget.decoration is BoxDecoration) {
    final decoration = widget.decoration as BoxDecoration;
    if (decoration.color != null) {
      attributes['color'] = decoration.color.value.toString();
    }
    attributes['decoration'] = <String, dynamic>{};
    if (decoration.borderRadius != null) {
      attributes['decoration']['borderRadius'] =
          decoration.borderRadius.toString();
    }
    if (decoration.boxShadow != null) {
      attributes['decoration']['boxShadow'] = decoration.boxShadow.map((e) {
        return {
          'color': e.color.value.toString(),
          'offset': e.offset.toString(),
          'blurRadius': e.blurRadius,
          'spreadRadius': e.spreadRadius,
        };
      }).toList();
    }
    if (decoration.border != null && decoration.border is Border) {
      attributes['decoration']['border'] = {
        'topWidth': (decoration.border as Border).top.width,
        'topColor': (decoration.border as Border).top.color.value.toString(),
        'topStyle': (decoration.border as Border).top.style.toString(),
        'leftWidth': (decoration.border as Border).left.width,
        'leftColor': (decoration.border as Border).left.color.value.toString(),
        'leftStyle': (decoration.border as Border).left.style.toString(),
        'bottomWidth': (decoration.border as Border).bottom.width,
        'bottomColor':
            (decoration.border as Border).bottom.color.value.toString(),
        'bottomStyle': (decoration.border as Border).bottom.style.toString(),
        'rightWidth': (decoration.border as Border).right.width,
        'rightColor':
            (decoration.border as Border).right.color.value.toString(),
        'rightStyle': (decoration.border as Border).right.style.toString(),
      };
    }
  }
  return MPElement(
    name: 'decorated_box',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: attributes,
  );
}
