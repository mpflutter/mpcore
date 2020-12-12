library mpcore;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'channel/channel_io.dart'
    if (dart.library.js) './channel/channel_js.dart';
import 'package:mpkit/mpkit.dart';

part 'document.dart';
part 'body.dart';
part 'plugin.dart';
part './components/absorb_pointer.dart';
part './components/custom_scroll_view.dart';
part './components/gesture_detector.dart';
part './components/opacity.dart';
part './components/sliver_list.dart';
part './components/align.dart';
part './components/decorated_box.dart';
part './components/icon.dart';
part './components/padding.dart';
part './components/stack.dart';
part './components/clip_oval.dart';
part './components/div_box.dart';
part './components/ignore_pointer.dart';
part './components/positioned.dart';
part './components/tab_bar.dart';
part './components/clip_r_rect.dart';
part './components/divider.dart';
part './components/image.dart';
part './components/rich_text.dart';
part './components/transform.dart';
part './components/colored_box.dart';
part './components/flex.dart';
part './components/list_view.dart';
part './components/scroller.dart';
part './components/visibility.dart';
part './components/constrained_box.dart';
part './components/flexible.dart';
part './components/offstage.dart';
part './components/sized_box.dart';
part './components/editable_text.dart';
part './components/action.dart';
part './components/web_dialogs.dart';
part './channel/channel_base.dart';

class MPCore {
  static String getInitialRoute() {
    return MPChannel.getInitialRoute();
  }

  static NavigatorObserver getNavigationObserver() {
    return MPNavigatorObserver.instance;
  }

  static final _plugins = <MPPlugin>[];

  static void registerPlugin(MPPlugin plugin) {
    _plugins.add(plugin);
  }

  MPCore();

  Element get renderView => WidgetsBinding.instance.renderViewElement;

  void connectToHostChannel() async {
    final _ = MPChannel.setupHotReload(this);
    sendFrame();
  }

  Future handleHotReload() async {
    try {
      markNeedsBuild(renderView);
      sendFrame();
    } catch (e) {
      print(e);
    }
  }

  void sendFrame() async {
    await nextFrame();
    final frameData = json.encode({
      'type': 'frame_data',
      'message': toDocument(),
    });
    MPChannel.postMesssage(frameData);
    sendFrame();
  }

  Future nextFrame() async {
    final completer = Completer();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete();
    });
    return completer.future;
  }

  _Document toDocument() {
    if (renderView == null) return null;
    final tabBodyElement = findTarget<MPTabBody>(renderView);
    if (tabBodyElement != null) {
      final hasListBody = findTarget<Scrollable>(
              findFirstChild(findTargetKey(Key('tab_body'), tabBodyElement))) !=
          null;
      final vDocument = _Document(
        header: MPElement.fromFlutterElement(
          findFirstChild(findTargetKey(Key('tab_header'), tabBodyElement)),
        ),
        tabBar: MPElement.fromFlutterElement(
          findTarget<TabBar>(tabBodyElement),
        ),
        body: MPElement.fromFlutterElement(
          findFirstChild(findTargetKey(Key('tab_body'), tabBodyElement)),
        ),
        isTabBody: true,
        isListBody: hasListBody,
      );
      return vDocument;
    }
    final scaffoldElement = findTarget<Scaffold>(renderView);
    if (scaffoldElement != null) {
      final bodyElement = findTarget<ScaffoldBodyBuilder>(scaffoldElement);
      final vBody = MPElement.fromFlutterElement(bodyElement);
      final hasListBody = findTarget<Scrollable>(bodyElement) != null;
      final vDocument = _Document(body: vBody, isListBody: hasListBody);
      return vDocument;
    }
    final minipScaffoldElement = findTarget<MPScaffold>(renderView);
    if (minipScaffoldElement != null) {
      final bodyElement = minipScaffoldElement;
      final vBody = MPElement.fromFlutterElement(bodyElement);
      final hasListBody = findTarget<Scrollable>(bodyElement) != null;
      final vDocument = _Document(
        body: vBody,
        isListBody:
            (minipScaffoldElement.widget as MPScaffold).isListBody != false &&
                hasListBody,
      );
      return vDocument;
    }
    return null;
  }

  static Element findTarget<T>(Element element, {bool findParent = false}) {
    Element targetElement;
    element.visitChildElements((el) {
      if (el.widget is T) {
        if (findParent == true) {
          targetElement = element;
        } else {
          targetElement = el;
        }
      } else {
        final next = findTarget<T>(el, findParent: findParent);
        if (next != null) {
          targetElement = next;
        }
      }
    });
    return targetElement;
  }

  static Element findTargetHashCode(
    int hashCode, {
    Element element,
  }) {
    element ??= WidgetsBinding.instance.renderViewElement;
    Element targetElement;
    element.visitChildElements((el) {
      if (el.hashCode == hashCode) {
        targetElement = el;
      } else {
        final next = findTargetHashCode(hashCode, element: el);
        if (next != null) {
          targetElement = next;
        }
      }
    });
    return targetElement;
  }

  static Element findTargetKey(Key key, Element element,
      {bool findParent = false}) {
    Element targetElement;
    element.visitChildElements((el) {
      if (el.widget?.key == key) {
        if (findParent == true) {
          targetElement = element;
        } else {
          targetElement = el;
        }
      } else {
        final next = findTargetKey(key, el, findParent: findParent);
        if (next != null) {
          targetElement = next;
        }
      }
    });
    return targetElement;
  }

  static Element findFirstChild(Element element) {
    Element targetElement;
    element.visitChildElements((el) {
      targetElement ??= el;
    });
    return targetElement;
  }

  static void markNeedsBuild(Element element) {
    element.markNeedsBuild();
    element.visitChildElements((el) {
      markNeedsBuild(el);
    });
  }

  static void printElement(Element element, {int level = 0}) {
    if (element == null) return;
    element.visitChildElements((el) {
      print(level);
      print(el);
      printElement(el, level: level + 1);
    });
  }
}
