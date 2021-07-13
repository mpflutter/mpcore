// ignore: avoid_web_libraries_in_flutter

import 'dart:js' as js;

import '../mpcore.dart';

js.JsObject engineScope = js.context['engineScope'];

class MPChannel {
  static bool _isClientAttached = false;

  static void setupHotReload(MPCore minip) async {
    _setupLocalServer();
  }

  static void _setupLocalServer() async {
    _isClientAttached = true;
    engineScope['postMessage'] = (String message) {
      MPChannelBase.handleClientMessage(message);
    };
    _flushMessageQueue();
    MPChannelBase.updateWindowSize();
  }

  static void postMesssage(String message, {bool? forLastConnection}) {
    if (!_isClientAttached) {
      _addMessageToQueue(message);
      return;
    }
    engineScope.callMethod('onMessage', [message]);
  }

  static String getInitialRoute() {
    // try {
    //   if (js.context.hasProperty('Taro')) {
    //     try {
    //       return Uri.decodeFull(js.context['location']['href'] ?? '/');
    //     } catch (e) {
    //       return js.context['location']['href'] ?? '/';
    //     }
    //   }
    //   final uri = Uri.parse(js.context['location']['href']);
    //   final uriRoute = uri.queryParameters['route'];
    //   if (uriRoute != null) {
    //     return uriRoute;
    //   }
    // } catch (e) {
    //   print(e);
    // }
    return '/';
  }

  static void onSubPackageNavigate(String pkgName, String routeName) {
    if (pkgName == 'main') {
      pkgName = 'index';
    }
    // if (js.context.hasProperty('Taro')) {
    //   js.context.callMethod('locationToSubPackage', [pkgName, routeName]);
    // } else {
    //   js.context['location']['href'] =
    //       '${pkgName}.html?route=${Uri.encodeFull(routeName)}';
    // }
  }

  static final List<String> _messageQueue = [];

  static void _addMessageToQueue(String message) {
    _messageQueue.add(message);
  }

  static void _flushMessageQueue() {
    for (var item in _messageQueue) {
      engineScope.callMethod('onMessage', [item]);
    }
    _messageQueue.clear();
  }
}
