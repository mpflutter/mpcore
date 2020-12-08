part of '../mpcore.dart';

_Element _encodeRichText(Element element) {
  final widget = element.widget as RichText;
  return _Element(name: 'rich_text', children: [
    _encodeTextSpan(widget.text)
  ], attributes: {
    'maxLines': widget.maxLines,
  });
}

_Element _encodeTextSpan(InlineSpan span) {
  if (span is TextSpan) {
    return _Element(
      name: 'text_span',
      children: span.children?.map((e) => _encodeTextSpan(e))?.toList(),
      attributes: {
        'text': span.text,
        'style': _encodeTextStyle(span.style),
      },
    );
  } else {
    return _Element(
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
