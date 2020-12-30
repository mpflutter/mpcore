part of '../mpcore.dart';

MPElement _encodeGridView(Element element) {
  final indexedSemanticeParentElement = MPCore.findTarget<KeyedSubtree>(
    element,
    findParent: true,
  );
  if (indexedSemanticeParentElement == null) {
    return MPElement(
      name: 'grid_view',
      children: [],
    );
  }
  final widget = element.widget as GridView;

  return MPElement(
    name: 'grid_view',
    children: MPElement.childrenFromFlutterElement(
      indexedSemanticeParentElement,
    ),
    attributes: {
      'scrollDirection': widget.scrollDirection?.toString(),
      'padding': widget.padding?.toString(),
      'width': element
          .findAncestorWidgetOfExactType<Container>()
          ?.constraints
          ?.minWidth
          ?.toString(),
      'gridDelegate': _encodeGridDelegate(widget.gridDelegate),
    },
  );
}

MPElement _encodeSliverWaterfallItem(Element element) {
  final widget = element.widget as SliverWaterfallItem;
  return MPElement(
    name: 'sliver_waterfall_item',
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {'height': widget.size?.height},
  );
}

Map _encodeGridDelegate(dynamic delegate) {
  if (delegate == null) return null;
  if (delegate is SliverWaterfallDelegate) {
    return {
      'classname': 'SliverWaterfallDelegate',
      'mainAxisSpacing': delegate.mainAxisSpacing,
      'crossAxisSpacing': delegate.crossAxisSpacing,
      'crossAxisCount': delegate.crossAxisCount,
    };
  } else if (delegate is SliverGridDelegateWithFixedCrossAxisCount) {
    return {
      'classname': 'SliverGridDelegateWithFixedCrossAxisCount',
      'mainAxisSpacing': delegate.mainAxisSpacing,
      'crossAxisSpacing': delegate.crossAxisSpacing,
      'crossAxisCount': delegate.crossAxisCount,
      'childAspectRatio': delegate.childAspectRatio,
    };
  } else if (delegate is SliverGridDelegateWithMaxCrossAxisExtent) {
    return {
      'classname': 'SliverGridDelegateWithMaxCrossAxisExtent',
      'mainAxisSpacing': delegate.mainAxisSpacing,
      'crossAxisSpacing': delegate.crossAxisSpacing,
      'maxCrossAxisExtent': delegate.maxCrossAxisExtent,
      'childAspectRatio': delegate.childAspectRatio,
    };
  } else {
    return null;
  }
}
