part of '../mpcore.dart';

MPElement _encodeMPWebView(Element element) {
  final widget = element.widget as MPWebView;
  return MPElement(
    name: 'mp_web_view',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'url': widget.url,
    },
  );
}
