// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'dart:convert';

import 'channel_base.dart';

import '../mpcore.dart';

class MPChannel {
  static bool messageHandlerSetted = false;

  static void setupHotReload(MPCore minip) async {}

  static void postMesssage(String message) {
    if (!messageHandlerSetted) {
      messageHandlerSetted = true;
      window.addEventListener('message', (event) {
        final data = (event as MessageEvent).data;
        final obj = json.decode(data);
        if (obj['type'] == 'gesture_detector') {
          MPChannelBase.onGestureDetectorTrigger(obj['message']);
        } else if (obj['type'] == 'tab_bar') {
          MPChannelBase.onTabBarTrigger(obj['message']);
        } else if (obj['type'] == 'scroller') {
          MPChannelBase.onScrollerTrigger(obj['message']);
        } else if (obj['type'] == 'router') {
          MPChannelBase.onRouterTrigger(obj['message']);
        }
      });
    }
    window.top.postMessage(message, '*');
  }

  static String getInitialRoute() {
    try {
      final uri = Uri.parse(window.location.href);
      final uriRoute = uri.queryParameters['route'];
      if (uriRoute != null) {
        return uriRoute;
      }
    } catch (e) {
      print(e);
    }
    return '/';
  }
}
