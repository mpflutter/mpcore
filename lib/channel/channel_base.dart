import 'dart:convert';

import 'package:flutter/material.dart';
import '../mpcore.dart';
import 'channel_io.dart'
    if (dart.library.js) '../channel/minip_channel_js.dart';

class MPNavigatorObserver extends NavigatorObserver {
  static final instance = MPNavigatorObserver();

  static bool doBacking = false;

  @override
  void didPush(Route route, Route previousRoute) {
    if (previousRoute == null) return;
    final routeData = json.encode({
      'type': 'route',
      'message': json.encode({
        'event': 'didPush',
        'route': {
          'hash': route.hashCode,
          'name': route.settings?.name ?? '/',
        }
      }),
    });
    MPChannel.postMesssage(routeData);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    if (doBacking) return;
    final routeData = json.encode({
      'type': 'route',
      'message': json.encode({
        'event': 'didPop',
        'route': {
          'hash': previousRoute.hashCode,
          'name': previousRoute.settings?.name ?? '/',
        }
      }),
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
  static onGestureDetectorTrigger(Map message) {
    try {
      final GestureDetector widget =
          gestureDetectorHandlers[message['target']]?.widget;
      if (widget == null) return;
      if (message['event'] == 'onTap') {
        widget.onTap?.call();
      }
    } catch (e) {
      print(e);
    }
  }

  static onTabBarTrigger(Map message) {
    try {
      final TabBar widget = tabBarHandlers[message['target']]?.widget;
      if (widget == null) return;
      if (message['event'] == 'onTapIndex') {
        widget.controller.index = message['data'];
      }
    } catch (e) {
      print(e);
    }
  }

  static onScrollerTrigger(Map message) {
    try {
      if (message['event'] == 'onScrollToBottom') {
        ScrollToBottomNotifier.instance.notify();
      }
    } catch (e) {
      print(e);
    }
  }

  static onRouterTrigger(Map message) {
    try {
      if (message['event'] == 'doPop') {
        MPNavigatorObserver.doBacking = true;
        if (MPNavigatorObserver.instance.navigator.canPop()) {
          MPNavigatorObserver.instance.navigator.pop();
        }
        MPNavigatorObserver.doBacking = false;
      }
    } catch (e) {
      print(e);
    }
  }
}
