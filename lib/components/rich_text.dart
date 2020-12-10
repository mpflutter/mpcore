part of '../mpcore.dart';

MPElement _encodeRichText(Element element) {
  final widget = element.widget as RichText;
  return MPElement(name: 'rich_text', children: [
    _encodeTextSpan(widget.text)
  ], attributes: {
    'maxLines': widget.maxLines,
  });
}

MPElement _encodeTextSpan(InlineSpan span) {
  if (span is TextSpan) {
    return MPElement(
      name: 'text_span',
      children: span.children?.map((e) => _encodeTextSpan(e))?.toList(),
      attributes: {
        'text': span.text,
        'style': _encodeTextStyle(span.style),
      },
    );
  } else {
    return MPElement(
      name: 'inline_span',
      attributes: {},
    );
  }
}

Map _encodeTextStyle(TextStyle style) {
  final map = {};
  if (style?.fontFamily != null) {
    map['fontFamily'] = style.fontFamily;
  }
  if (style?.fontSize != null) {
    map['fontSize'] = style.fontSize;
  }
  if (style?.color != null) {
    map['color'] = style.color.value.toString();
  }
  if (style?.fontWeight != null) {
    map['fontWeight'] = style.fontWeight.toString();
  }
  if (style?.fontStyle != null) {
    map['fontStyle'] = style.fontStyle.toString();
  }
  if (style?.letterSpacing != null) {
    map['letterSpacing'] = style.letterSpacing;
  }
  if (style?.wordSpacing != null) {
    map['wordSpacing'] = style.wordSpacing;
  }
  if (style?.textBaseline != null) {
    map['textBaseline'] = style.textBaseline.toString();
  }
  if (style?.height != null) {
    map['height'] = style.height;
  }
  if (style?.backgroundColor != null) {
    map['backgroundColor'] = style.backgroundColor.value.toString();
  }
  return map;
}
