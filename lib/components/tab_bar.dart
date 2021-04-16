part of '../mpcore.dart';

MPElement _encodeTabBar(Element element) {
  final widget = element.widget as TabBar;
  return MPElement(
    hashCode: element.hashCode,
    name: 'tab_bar',
    children: widget.tabs.whereType<Tab>().map((e) => _encodeTab(e)).toList(),
    attributes: {
      'onTapIndex': element.hashCode,
      'selected': widget.controller.index,
    },
  );
}

MPElement _encodeTab(Tab widget) {
  return MPElement(
    hashCode: widget.hashCode,
    name: 'tab',
    children: null,
    attributes: {
      'text': widget.text?.toString(),
    },
  );
}
