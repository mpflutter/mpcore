// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:js' as js;
import 'package:mpcore/mpjs/mpjs.dart';

import '../mpcore.dart';

class MPChannel {
  static bool _messageHandlerSetted = false;
  static bool _isClientAttached = false;

  static void setupHotReload(MPCore minip) async {
    while (!_isClientAttached) {
      _checkClientAttached();
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  static void _checkClientAttached() {
    if (Taro.isTaro) {
      _isClientAttached = true;
      _flushMessageQueue();
    } else if (js.context['mpClientAttached'] == true) {
      _isClientAttached = true;
      _flushMessageQueue();
    }
  }

  static void postMesssage(String message, {bool? forLastConnection}) {
    if (!_messageHandlerSetted) {
      _messageHandlerSetted = true;
      js.context.callMethod('addEventListener', [
        'message',
        (event) {
          final data = (() {
            if (event is js.JsObject) {
              return event['data'];
            } else {
              try {
                return event.data;
              } catch (e) {
                return '';
              }
            }
          })();
          final obj = json.decode(data);
          if (obj['type'] == 'gesture_detector') {
            MPChannelBase.onGestureDetectorTrigger(obj['message']);
          } else if (obj['type'] == 'overlay') {
            MPChannelBase.onOverlayTrigger(obj['message']);
          } else if (obj['type'] == 'rich_text') {
            MPChannelBase.onRichTextTrigger(obj['message']);
          } else if (obj['type'] == 'scroller') {
            MPChannelBase.onScrollerTrigger(obj['message']);
          } else if (obj['type'] == 'decode_drawable') {
            MPChannelBase.onDecodeDrawable(obj['message']);
          } else if (obj['type'] == 'router') {
            MPChannelBase.onRouterTrigger(obj['message']);
          } else if (obj['type'] == 'editable_text') {
            MPChannelBase.onEditableTextTrigger(obj['message']);
          } else if (obj['type'] == 'action') {
            MPChannelBase.onActionTrigger(obj['message']);
          } else if (obj['type'] == 'mpjs' && obj['flow'] != 'request') {
            JsBridgeInvoker.instance.makeResponse(obj['message']);
          } else if (obj['type'] == 'fragment') {
            MPChannelBase.onFragment(obj['message']);
          } else {
            MPChannelBase.onPluginMessage(obj);
          }
        }
      ]);
    }
    if (!_isClientAttached) {
      _addMessageToQueue(message);
      _checkClientAttached();
      return;
    }
    try {
      (js.context['top'] as js.JsObject)
          .callMethod('postMessage', [message, '*']);
    } catch (e) {
      js.context.callMethod('postMessage', [message, '*']);
    }
  }

  static String getInitialRoute() {
    try {
      if (Taro.isTaro) {
        return Uri.decodeFull(js.context['location']['href'] ?? '/');
      }
      final uri = Uri.parse(js.context['location']['href']);
      final uriRoute = uri.queryParameters['route'];
      if (uriRoute != null) {
        return Uri.decodeFull(uriRoute);
      }
    } catch (e) {
      print(e);
    }
    return '/';
  }

  static void onSubPackageNavigate(String pkgName, String routeName) {
    if (pkgName == 'main') {
      pkgName = 'index';
    }
    if (Taro.isTaro) {
      js.context.callMethod('locationToSubPackage', [pkgName, routeName]);
    } else {
      js.context['location']['href'] =
          '${pkgName}.html?route=${Uri.encodeFull(routeName)}';
    }
  }

  static final List<String> _messageQueue = [];

  static void _addMessageToQueue(String message) {
    _messageQueue.add(message);
  }

  static void _flushMessageQueue() {
    for (var item in _messageQueue) {
      try {
        (js.context['top'] as js.JsObject)
            .callMethod('postMessage', [item, '*']);
      } catch (e) {
        js.context.callMethod('postMessage', [item, '*']);
      }
    }
    _messageQueue.clear();
  }
}
