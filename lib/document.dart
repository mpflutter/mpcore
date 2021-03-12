part of './mpcore.dart';

class _Document {
  final int routeId;
  final MPElement mainTabBar;
  final MPElement scaffold;
  final List<MPElement> overlays;

  _Document({
    this.routeId,
    this.mainTabBar,
    this.scaffold,
    this.overlays,
  });

  Map toJson() {
    return {
      'routeId': routeId,
      'mainTabBar': mainTabBar,
      'scaffold': scaffold,
      'overlays': overlays,
    };
  }
}

class MPElement {
  final String name;
  final List<MPElement> children;
  final Constraints constraints;
  final Map<String, dynamic> attributes;

  MPElement({this.name, this.children, this.constraints, this.attributes});

  Map toJson() {
    return {
      'name': name,
      'children': children,
      'constraints': _encodeConstraints(),
      'attributes': attributes,
    };
  }

  Map _encodeConstraints() {
    if (constraints != null && constraints is BoxConstraints) {
      return {
        'minWidth': (constraints as BoxConstraints).minWidth.toString(),
        'minHeight': (constraints as BoxConstraints).minHeight.toString(),
        'maxWidth': (constraints as BoxConstraints).maxWidth.toString(),
        'maxHeight': (constraints as BoxConstraints).maxHeight.toString(),
        'hasTightWidth': (constraints as BoxConstraints).hasTightWidth,
        'hasTightHeight': (constraints as BoxConstraints).hasTightHeight,
        'isTight': (constraints as BoxConstraints).isTight,
      };
    } else {
      return null;
    }
  }

  static Map<Type, MPElement Function(Element)> fromFlutterElementMethodCache =
      {};

  static MPElement fromFlutterElement(Element element) {
    if (element == null) return null;
    if (fromFlutterElementMethodCache[element.widget.runtimeType] != null) {
      return fromFlutterElementMethodCache[element.widget.runtimeType](element);
    } else if (element.widget is ColoredBox) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeColoredBox;
      return _encodeColoredBox(element);
    } else if (element.widget is Align) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeAlign;
      return _encodeAlign(element);
    } else if (element.widget is RichText) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeRichText;
      return _encodeRichText(element);
    } else if (element.widget is ConstrainedBox) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeConstrainedBox;
      return _encodeConstrainedBox(element);
    } else if (element.widget is Flex) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeFlex;
      return _encodeFlex(element);
    } else if (element.widget is Padding) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodePadding;
      return _encodePadding(element);
    } else if (element.widget is SliverPadding) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverPadding;
      return _encodeSliverPadding(element);
    } else if (element.widget is ListView) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeListView;
      return _encodeListView(element);
    } else if (element.widget is GridView) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeGridView;
      return _encodeGridView(element);
    } else if (element.widget is SliverWaterfallItem) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverWaterfallItem;
      return _encodeSliverWaterfallItem(element);
    } else if (element.widget is SizedBox) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSizedBox;
      return _encodeSizedBox(element);
    } else if (element.widget is DecoratedBox) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeDecoratedBox;
      return _encodeDecoratedBox(element);
    } else if (element.widget is Divider) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeDivider;
      return _encodeDivider(element);
    } else if (element.widget is Image) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeImage;
      return _encodeImage(element);
    } else if (element.widget is ClipOval) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeClipOval;
      return _encodeClipOval(element);
    } else if (element.widget is ClipRRect) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeClipRRect;
      return _encodeClipRRect(element);
    } else if (element.widget is ClipRect) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeClipRect;
      return _encodeClipRect(element);
    } else if (element.widget is Opacity) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeOpacity;
      return _encodeOpacity(element);
    } else if (element.widget is SliverOpacity) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverOpacity;
      return _encodeSliverOpacity(element);
    } else if (element.widget is Flexible) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeFlexible;
      return _encodeFlexible(element);
    } else if (element.widget is GestureDetector) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeGestureDetector;
      return _encodeGestureDetector(element);
    } else if (element.widget is Stack) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeStack;
      return _encodeStack(element);
    } else if (element.widget is Positioned) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodePositioned;
      return _encodePositioned(element);
    } else if (element.widget is Visibility) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeVisibility;
      return _encodeVisibility(element);
    } else if (element.widget is SliverVisibility) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverVisibility;
      return _encodeSliverVisibility(element);
    } else if (element.widget is Offstage) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeOffstage;
      return _encodeOffstage(element);
    } else if (element.widget is SliverOffstage) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverOffstage;
      return _encodeSliverOffstage(element);
    } else if (element.widget is Transform) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeTransform;
      return _encodeTransform(element);
    } else if (element.widget is IgnorePointer) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeIgnorePointer;
      return _encodeIgnorePointer(element);
    } else if (element.widget is AbsorbPointer) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeAbsorbPointer;
      return _encodeAbsorbPointer(element);
    } else if (element.widget is Icon) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeIcon;
      return _encodeIcon(element);
    } else if (element.widget is CustomScrollView) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeCustomScrollView;
      return _encodeCustomScrollView(element);
    } else if (element.widget is SliverList) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverList;
      return _encodeSliverList(element);
    } else if (element.widget is SliverGrid) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverGrid;
      return _encodeSliverGrid(element);
    } else if (element.widget is TabBar) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeTabBar;
      return _encodeTabBar(element);
    } else if (element.widget is EditableText) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeEditableText;
      return _encodeEditableText(element);
    } else if (element.widget is Wrap) {
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeWrap;
      return _encodeWrap(element);
    } else if (element.widget is SliverPersistentHeader) {
      fromFlutterElementMethodCache[element.widget.runtimeType] =
          _encodeSliverPersistentHeader;
      return _encodeSliverPersistentHeader(element);
    } else {
      final mpKitResult = MPKitEncoder.fromFlutterElement(element);
      if (mpKitResult != null) {
        return mpKitResult;
      }
      for (final plugin in MPCore._plugins) {
        final result = plugin.encodeElement(element);
        if (result != null) {
          return result;
        }
      }
      fromFlutterElementMethodCache[element.widget.runtimeType] = _encodeDivBox;
      return _encodeDivBox(element);
    }
  }

  static List<MPElement> childrenFromFlutterElement(Element element) {
    final els = <MPElement>[];
    element.visitChildElements((element) {
      els.add(fromFlutterElement(element));
    });
    return els;
  }
}
