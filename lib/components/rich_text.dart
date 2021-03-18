part of '../mpcore.dart';

Map<int, Element> _measuringText = {};

void _onMeasuredText(List values) {
  values.forEach((element) {
    if (element is Map) {
      final measureId = element['measureId'];
      final size = Size(
        (element['size']['width'] as num).toDouble(),
        (element['size']['height'] as num).toDouble(),
      );
      final fltElement = _measuringText[measureId];
      if (fltElement == null) {
        return;
      }
      _measuringText.remove(measureId);
      final renderObject = fltElement.findRenderObject();
      if (!(renderObject is RenderParagraph)) {
        return;
      }
      (renderObject as RenderParagraph).measuredSize = size;
      renderObject.reassemble();
    }
  });
  _measuringText.forEach((key, fltElement) {
    final renderObject = fltElement.findRenderObject();
    if (!(renderObject is RenderParagraph)) {
      return;
    }
    (renderObject as RenderParagraph).measuredSize = Size(0, 0);
    renderObject.reassemble();
  });
  _measuringText.clear();
  WidgetsBinding.instance.scheduleFrame();
}

MPElement _encodeRichText(Element element) {
  final widget = element.widget as RichText;
  final renderObject = element.findRenderObject();
  // ignore: invalid_use_of_protected_member
  var constraints = element.findRenderObject()?.constraints as BoxConstraints;
  if (renderObject is RenderParagraph && renderObject.measuredSize != null) {
    if (renderObject.size.width + 1.0 < renderObject.measuredSize.width ||
        renderObject.size.height + 1.0 < renderObject.measuredSize.height) {
      renderObject.measuredSize = null;
    } else {
      constraints = BoxConstraints(
        minWidth: renderObject.size.width,
        minHeight: renderObject.size.height,
        maxWidth: renderObject.size.width,
        maxHeight: renderObject.size.height,
      );
    }
  }
  if (renderObject is RenderParagraph && renderObject.measuredSize == null) {
    _measuringText[element.hashCode] = element;
  }
  return MPElement(
    name: 'rich_text',
    children: [_encodeSpan(widget.text, element)],
    constraints: constraints,
    attributes: {
      'measureId':
          renderObject is RenderParagraph && renderObject.measuredSize == null
              ? element.hashCode
              : null,
      'maxLines': widget.maxLines,
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
