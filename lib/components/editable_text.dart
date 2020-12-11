part of '../mpcore.dart';

MPElement _encodeEditableText(Element element) {
  final widget = element.widget as EditableText;
  return MPElement(
    name: 'editable_text',
    children: [],
    attributes: {
      'style': widget.style != null ? _encodeTextStyle(widget.style) : null,
      'value': widget.controller?.textDirty == true
          ? (widget.controller?.text ?? '')
          : null,
      'maxLines': widget.maxLines,
      'obscureText': widget.obscureText,
      'readOnly': widget.readOnly,
      'textAlign': widget.textAlign.toString(),
      'autofocus': widget.autofocus,
      'autocorrect': widget.autocorrect,
      'enableSuggestions': widget.enableSuggestions,
      'keyboardType': widget.keyboardType.toString(),
      'onSubmitted': widget.onSubmitted != null ? element.hashCode : null,
      'onChanged': element.hashCode,
    },
  );
}
