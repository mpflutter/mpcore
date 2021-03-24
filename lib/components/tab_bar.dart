part of '../mpcore.dart';

MPElement _encodeTabBar(Element element) {
  final widget = element.widget as TabBar;
  return MPElement(
    hashCode: element.hashCode,
    name: 'tab_bar',
    children: widget.tabs.map((e) => _encodeTab(e)).toList(),
    attributes: {
      'onTapIndex': element.hashCode,
      'selected': widget.controller.index,
    },
  );
}

MPElement _encodeTab(Tab widget) {
  return MPElement(
    name: 'tab',
    children: null,
    attributes: {
      'text': widget.text?.toString(),
    },
  );
}
