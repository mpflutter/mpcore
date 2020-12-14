part of './mpcore.dart';

class _Document {
  final MPElement header;
  final MPElement tabBar;
  final MPElement body;
  final Color backgroundColor;
  final bool isListBody;
  final bool isTabBody;

  _Document({
    this.header,
    this.tabBar,
    this.body,
    this.backgroundColor,
    this.isListBody,
    this.isTabBody,
  });

  Map toJson() {
    return {
      'header': header,
      'tabBar': tabBar,
      'body': body,
      'backgroundColor': backgroundColor?.value?.toString(),
      'isListBody': isListBody,
      'isTabBody': isTabBody
    };
  }
}

class MPElement {
  final String name;
  final List<MPElement> children;
  final Map<String, dynamic> attributes;

  MPElement({this.name, this.children, this.attributes});

  Map toJson() {
    return {
      'name': name,
      'children': children,
      'attributes': attributes,
    };
  }

  static MPElement fromFlutterElement(Element element) {
    if (element == null) return null;
    if (element.widget is ColoredBox) {
      return _encodeColoredBox(element);
    } else if (element.widget is Align) {
      return _encodeAlign(element);
    } else if (element.widget is RichText) {
      return _encodeRichText(element);
    } else if (element.widget is ConstrainedBox) {
      return _encodeConstrainedBox(element);
    } else if (element.widget is Flex) {
      return _encodeFlex(element);
    } else if (element.widget is Padding) {
      return _encodePadding(element);
    } else if (element.widget is SliverPadding) {
      return _encodeSliverPadding(element);
    } else if (element.widget is ListView) {
      return _encodeListView(element);
    } else if (element.widget is SizedBox) {
      return _encodeSizedBox(element);
    } else if (element.widget is DecoratedBox) {
      return _encodeDecoratedBox(element);
    } else if (element.widget is Divider) {
      return _encodeDivider(element);
    } else if (element.widget is Image) {
      return _encodeImage(element);
    } else if (element.widget is ClipOval) {
      return _encodeClipOval(element);
    } else if (element.widget is ClipRRect) {
      return _encodeClipRRect(element);
    } else if (element.widget is ClipRect) {
      return _encodeClipRect(element);
    } else if (element.widget is Opacity) {
      return _encodeOpacity(element);
    } else if (element.widget is SliverOpacity) {
      return _encodeSliverOpacity(element);
    } else if (element.widget is Flexible) {
      return _encodeFlexible(element);
    } else if (element.widget is GestureDetector) {
      return _encodeGestureDetector(element);
    } else if (element.widget is Stack) {
      return _encodeStack(element);
    } else if (element.widget is Positioned) {
      return _encodePositioned(element);
    } else if (element.widget is Visibility) {
      return _encodeVisibility(element);
    } else if (element.widget is SliverVisibility) {
      return _encodeSliverVisibility(element);
    } else if (element.widget is Offstage) {
      return _encodeOffstage(element);
    } else if (element.widget is SliverOffstage) {
      return _encodeSliverOffstage(element);
    } else if (element.widget is Transform) {
      return _encodeTransform(element);
    } else if (element.widget is IgnorePointer) {
      return _encodeIgnorePointer(element);
    } else if (element.widget is AbsorbPointer) {
      return _encodeAbsorbPointer(element);
    } else if (element.widget is Icon) {
      return _encodeIcon(element);
    } else if (element.widget is CustomScrollView) {
      return _encodeCustomScrollView(element);
    } else if (element.widget is SliverList) {
      return _encodeSliverList(element);
    } else if (element.widget is TabBar) {
      return _encodeTabBar(element);
    } else if (element.widget is EditableText) {
      return _encodeEditableText(element);
    } else {
      for (final plugin in MPCore._plugins) {
        final result = plugin.encodeElement(element);
        if (result != null) {
          return result;
        }
      }
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
