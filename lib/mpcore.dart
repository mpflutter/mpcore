library mpcore;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'channel/channel_io.dart'
    if (dart.library.js) './channel/channel_js.dart';
import './mpkit/mpkit.dart';
import 'mpkit/encoder/mpkit_encoder.dart';

export './mpkit/mpkit.dart';
export './taro/taro.dart';

part 'document.dart';
part 'body.dart';
part 'plugin.dart';
part './components/absorb_pointer.dart';
part './components/custom_scroll_view.dart';
part './components/gesture_detector.dart';
part './components/opacity.dart';
part './components/sliver_list.dart';
part './components/sliver_grid.dart';
part './components/align.dart';
part './components/decorated_box.dart';
part './components/icon.dart';
part './components/padding.dart';
part './components/stack.dart';
part './components/overlay.dart';
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
part './components/grid_view.dart';
part './components/scroller.dart';
part './components/visibility.dart';
part './components/constrained_box.dart';
part './components/flexible.dart';
part './components/offstage.dart';
part './components/sized_box.dart';
part './components/editable_text.dart';
part './components/action.dart';
part './components/wrap.dart';
part './components/sliver_persistent_header.dart';
part './components/web_dialogs.dart';
part './channel/channel_base.dart';

class MPCore {
  static Map<String, String> routeMapSubPackages;

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

  // static Map _oldFrameObject;

  static void clearOldFrameObject() {
    // _oldFrameObject = null;
  }

  void connectToHostChannel() async {
    final _ = MPChannel.setupHotReload(this);
    while (true) {
      try {
        await sendFrame();
      } catch (e) {
        print(e);
      }
    }
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
    var textMeasuringRetryMax = 20;
    while (_measuringText.isNotEmpty && textMeasuringRetryMax > 0) {
      await Future.delayed(Duration(milliseconds: 100));
      textMeasuringRetryMax--;
    }
    if (textMeasuringRetryMax <= 0) {
      _measuringText.clear();
    }
    if (BuildOwner.recentDirtyElements.isNotEmpty &&
        BuildOwner.recentDirtyElements.length == 1) {
      final doc = toDiffDocument(BuildOwner.recentDirtyElements[0]);
      final diffFrameData = json.encode({
        'type': 'diff_data',
        'message': doc,
      });
      final frameData = diffFrameData;
      MPChannel.postMesssage(frameData);
      BuildOwner.recentDirtyElements.clear();
    } else {
      final doc = toDocument();
      final newFrameData = json.encode({
        'type': 'frame_data',
        'message': doc,
      });
      final frameData = newFrameData;
      MPChannel.postMesssage(frameData);
    }
  }

  Future nextFrame() async {
    final completer = Completer();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete();
    });
    return completer.future;
  }

  _Document toDiffDocument(Element diffElement) {
    return _Document(
      diff: MPElement.fromFlutterElement(diffElement),
      diffIndex: diffElement.hashCode,
    );
  }

  _Document toDocument() {
    if (renderView == null) return null;
    Element activeScaffoldElement;
    Element mainTabElement;
    final scaffoldElements = <Element>[];
    final overlays = <MPElement>[];
    findTargetsTwo<MPScaffold, MPMainTab>(renderView,
        out: scaffoldElements, mustCurrentRoute: true);
    activeOverlayParentRoute = null;
    for (var scaffoldElement in scaffoldElements) {
      if (scaffoldElement.widget is MPOverlayScaffold) {
        overlays.add(_encodeOverlay(scaffoldElement));
      } else if (scaffoldElement.widget is MPScaffold) {
        if (scaffoldElement.findAncestorWidgetOfExactType<MPScaffold>() !=
            null) {
          continue;
        }
        activeScaffoldElement = scaffoldElement;
      } else if (scaffoldElement.widget is MPMainTab) {
        mainTabElement = scaffoldElement;
      }
    }
    if (activeScaffoldElement != null) {
      final vDocument = _Document(
        routeId: (() {
          final route = ModalRoute.of(activeScaffoldElement);
          if (route != null && route.isFirst) {
            return 0;
          } else if (route != null) {
            return route.hashCode;
          } else {
            return 0;
          }
        })(),
        mainTabBar: mainTabElement != null
            ? MPElement.fromFlutterElement(
                MPCore.findTargetKey(Key('mainTabBar'), mainTabElement))
            : null,
        scaffold: activeScaffoldElement != null
            ? MPElement.fromFlutterElement(activeScaffoldElement)
            : null,
        overlays: overlays,
      );
      return vDocument;
    } else {
      return null;
    }
  }

  static Element findTarget<T>(Element element, {bool findParent = false}) {
    if (element == null) {
      return null;
    }
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

  static void findTargets<T>(Element element,
      {List out, bool findParent = false}) {
    element.visitChildElements((el) {
      if (el.widget is T) {
        if (findParent == true) {
          out.add(element);
        } else {
          out.add(el);
        }
      }
      findTargets<T>(el, out: out, findParent: findParent);
    });
  }

  static ModalRoute activeOverlayParentRoute;

  static void findTargetsTwo<T, U>(
    Element element, {
    List out,
    bool findParent = false,
    bool mustCurrentRoute = false,
  }) {
    var els = <Element>[];
    element.visitChildElements((el) {
      els.add(el);
    });
    els.reversed.forEach((el) {
      if (el.widget is T || el.widget is U) {
        if (mustCurrentRoute &&
            ModalRoute.of(el)?.isCurrent != true &&
            ModalRoute.of(el) != activeOverlayParentRoute) {
          if (!(el.widget is MPOverlayScaffold)) {
            return;
          }
        }
        if ((el.widget is MPOverlayScaffold)) {
          activeOverlayParentRoute =
              (el.widget as MPOverlayScaffold).parentRoute;
        }
        if (findParent == true) {
          out.add(element);
        } else {
          out.add(el);
        }
      }
      findTargetsTwo<T, U>(
        el,
        out: out,
        findParent: findParent,
        mustCurrentRoute: mustCurrentRoute,
      );
    });
  }

  static Element findTargetHashCode(
    int hashCode, {
    Element element,
  }) {
    element ??= WidgetsBinding.instance.renderViewElement;
    Element targetElement;
    element.visitChildElements((el) {
      if (el.hashCode == hashCode || el.widget.hashCode == hashCode) {
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

  static TextSpan findTargetTextSpanHashCode(
    int hashCode, {
    InlineSpan element,
  }) {
    if (element.hashCode == hashCode) {
      return element;
    } else {
      TextSpan next;
      // ignore: deprecated_member_use
      element.children?.forEach((span) {
        next ??= findTargetTextSpanHashCode(hashCode, element: span);
      });
      if (next != null) {
        return next;
      } else {
        return null;
      }
    }
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
    if (element == null) return null;
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
