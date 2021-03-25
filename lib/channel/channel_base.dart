part of '../mpcore.dart';

class MPNavigatorObserver extends NavigatorObserver {
  static final instance = MPNavigatorObserver();

  static bool doBacking = false;

  @override
  void didPush(Route route, Route previousRoute) {
    if (previousRoute == null) return;
    if (route.settings?.name?.startsWith('/mp_dialog/') == true) {
      return;
    }
    final routeData = json.encode({
      'type': 'route',
      'message': {
        'event': 'didPush',
        'route': {
          'hash': route.hashCode,
          'name': route.settings?.name ?? '/',
        }
      },
    });
    MPChannel.postMesssage(routeData);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    if (doBacking) return;
    if (route.settings?.name?.startsWith('/mp_dialog/') == true) {
      return;
    }
    final routeData = json.encode({
      'type': 'route',
      'message': {
        'event': 'didPop',
        'route': {
          'hash': previousRoute.hashCode,
          'name': previousRoute.settings?.name ?? '/',
        }
      },
    });
    MPChannel.postMesssage(routeData);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class MPChannelBase {
  static void onGestureDetectorTrigger(Map message) {
    print('onGestureDetectorTrigger start = ' +
        DateTime.now().millisecondsSinceEpoch.toString());
    try {
      final GestureDetector widget =
          MPCore.findTargetHashCode(message['target'])?.widget;
      if (widget == null) return;
      if (message['event'] == 'onTap') {
        widget.onTap?.call();
      }
      print('onGestureDetectorTrigger end = ' +
          DateTime.now().millisecondsSinceEpoch.toString());
    } catch (e) {
      print(e);
    }
  }

  static void onOverlayTrigger(Map message) {
    try {
      final MPOverlayScaffold widget =
          MPCore.findTargetHashCode(message['target'])?.widget;
      if (widget == null) return;
      if (message['event'] == 'onBackgroundTap') {
        widget.onBackgroundTap?.call();
      }
    } catch (e) {
      print(e);
    }
  }

  static void onRichTextTrigger(Map message) {
    try {
      final RichText widget =
          MPCore.findTargetHashCode(message['target'])?.widget;
      if (widget != null && message['event'] == 'onTap') {
        final span = MPCore.findTargetTextSpanHashCode(
          message['subTarget'],
          element: widget.text,
        );
        if (span != null && span.recognizer is TapGestureRecognizer) {
          (span.recognizer as TapGestureRecognizer).onTap?.call();
        }
      } else if (message['event'] == 'onMeasured') {
        _onMeasuredText(message['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  static void onTabBarTrigger(Map message) {
    try {
      final TabBar widget =
          MPCore.findTargetHashCode(message['target'])?.widget;
      if (widget == null) return;
      if (message['event'] == 'onTapIndex') {
        widget.controller.index = message['data'];
      }
    } catch (e) {
      print(e);
    }
  }

  static void onEditableTextTrigger(Map message) {
    try {
      final EditableText widget =
          MPCore.findTargetHashCode(message['target'])?.widget;
      if (widget == null) return;
      if (message['event'] == 'onSubmitted') {
        widget.onSubmitted?.call(message['data']);
      } else if (message['event'] == 'onChanged' && message['data'] is String) {
        widget.controller?.text = message['data'];
        widget.controller?.textDirty = false;
        widget.onChanged?.call(message['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  static void onScrollerTrigger(Map message) {
    try {
      if (message['event'] == 'onScrollToBottom') {
        ScrollToBottomNotifier.instance.notify();
      }
    } catch (e) {
      print(e);
    }
  }

  static void onActionTrigger(Map message) {
    try {
      MPAction.onActionTrigger(message);
    } catch (e) {
      print(e);
    }
  }

  static void onRouterTrigger(Map message) {
    try {
      if (message['event'] == 'doPop') {
        MPNavigatorObserver.doBacking = true;
        if (message['toRouteId'] != null) {
          MPNavigatorObserver.instance.navigator.popUntil((route) =>
              route.isFirst ||
              route.hashCode == int.tryParse(message['toRouteId']));
        } else {
          if (MPNavigatorObserver.instance.navigator.canPop()) {
            MPNavigatorObserver.instance.navigator.pop();
          }
        }
        MPNavigatorObserver.doBacking = false;
      } else if (message['event'] == 'doPush') {
        MPNavigatorObserver.instance.navigator.pushNamed(message['name']);
      }
    } catch (e) {
      print(e);
    }
  }

  static void onPluginMessage(Map message) {
    for (final plugin in MPCore._plugins) {
      plugin.onClientMessage(message);
    }
  }

  static void onSubPackageNavigate(String pkgName, String routeName) {}
}
