// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:js' as js;
import 'package:mpcore/mpjs/mpjs_js.dart';

import '../mpcore.dart';

class MPChannel {
  static bool messageHandlerSetted = false;

  static void setupHotReload(MPCore minip) async {}

  static void postMesssage(String message, {bool? forLastConnection}) {
    if (!messageHandlerSetted) {
      messageHandlerSetted = true;
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
          } else if (obj['type'] == 'router') {
            MPChannelBase.onRouterTrigger(obj['message']);
          } else if (obj['type'] == 'editable_text') {
            MPChannelBase.onEditableTextTrigger(obj['message']);
          } else if (obj['type'] == 'action') {
            MPChannelBase.onActionTrigger(obj['message']);
          } else if (obj['type'] == 'mpjs' && obj['flow'] != 'request') {
            JsBridgeInvoker.instance.makeResponse(obj['message']);
          } else {
            MPChannelBase.onPluginMessage(obj);
          }
        }
      ]);
    }
    try {
      (js.context['top'] as js.JsObject).callMethod('postMessage', [message]);
    } catch (e) {
      js.context.callMethod('postMessage', [message]);
    }
  }

  static String getInitialRoute() {
    try {
      if (Taro.isTaro) {
        return js.context['location']['href'] ?? '/';
      }
      final uri = Uri.parse(js.context['location']['href']);
      final uriRoute = uri.queryParameters['route'];
      if (uriRoute != null) {
        return uriRoute;
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
}
