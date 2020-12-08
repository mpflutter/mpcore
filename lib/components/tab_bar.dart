part of '../mpcore.dart';

Map<int, Element> tabBarHandlers = {};

_Element _encodeTabBar(Element element) {
  final widget = element.widget as TabBar;
  tabBarHandlers[element.hashCode] = element;
  return _Element(
    name: 'tab_bar',
    children: widget.tabs.map((e) => _encodeTab(e)).toList(),
    attributes: {
      'onTapIndex': element.hashCode,
      'selected': widget.controller.index,
    },
  );
}

_Element _encodeTab(Tab widget) {
  return _Element(
    name: 'tab',
    children: null,
    attributes: {
      'text': widget.text?.toString(),
    },
  );
}
