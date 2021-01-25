part of '../mpcore.dart';

MPElement _encodeRichText(Element element) {
  final widget = element.widget as RichText;
  return MPElement(
    name: 'rich_text',
    children: [_encodeSpan(widget.text, element)],
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    attributes: {
      'maxLines': widget.maxLines,
      'inline': element.findAncestorWidgetOfExactType<MPInlineText>() != null,
      'textAlign': widget.textAlign?.toString(),
    },
  );
}

MPElement _encodeSpan(InlineSpan span, Element richTextElement) {
  if (span is TextSpan) {
    return MPElement(
      name: 'text_span',
      children:
          span.children?.map((e) => _encodeSpan(e, richTextElement))?.toList(),
      attributes: {
        'text': span.text,
        'style': _encodeTextStyle(span.style),
        'onTap_el': (() {
          if (span.recognizer is TapGestureRecognizer) {
            return richTextElement.hashCode;
          }
        })(),
        'onTap_span': (() {
          if (span.recognizer is TapGestureRecognizer) {
            return span.hashCode;
          }
        })(),
      },
    );
  } else if (span is WidgetSpan) {
    final targetElement = MPCore.findTargetHashCode(span.child.hashCode,
        element: richTextElement);
    if (targetElement == null) {
      return MPElement(
        name: 'inline_span',
        attributes: {},
      );
    }
    return MPElement(
      name: 'widget_span',
      children: [MPElement.fromFlutterElement(targetElement)],
      attributes: {},
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
