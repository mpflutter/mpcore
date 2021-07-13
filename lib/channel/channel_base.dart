part of '../mpcore.dart';

class MPNavigatorObserver extends NavigatorObserver {
  static final instance = MPNavigatorObserver();

  static bool doBacking = false;

  static bool initialPushed = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!initialPushed && previousRoute == null) {
      initialPushed = true;
      return;
    }
    if (route.settings.name?.startsWith('/mp_dialog/') == true) {
      return;
    }
    final routeData = json.encode({
      'type': 'route',
      'message': {
        'event': 'didPush',
        'route': {
          'hash': route.hashCode,
          'name': route.settings.name ?? '/',
        }
      },
    });
    MPChannel.postMesssage(routeData);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (doBacking) return;
    if (route.settings.name?.startsWith('/mp_dialog/') == true) {
      return;
    }
    final routeData = json.encode({
      'type': 'route',
      'message': {
        'event': 'didPop',
        'route': {
          'hash': previousRoute.hashCode,
          'name': previousRoute?.settings.name ?? '/',
        }
      },
    });
    MPChannel.postMesssage(routeData);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class MPChannelBase {
  static void handleClientMessage(msg) {
    try {
      final obj = json.decode(msg);
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
      } else if (obj['type'] == 'mpjs') {
        mpjs.JsBridgeInvoker.instance.makeResponse(obj['message']);
      } else if (obj['type'] == 'fragment') {
        MPChannelBase.onFragment(obj['message']);
      } else {
        MPChannelBase.onPluginMessage(obj);
      }
    } catch (e) {
      print(e);
    }
  }

  static void updateWindowSize() async {
    final num clientWidth;
    final num clientHeight;
    if (await mpjs.context['engineScope'].hasProperty('viewSize')) {
      clientWidth = await mpjs.context['engineScope']['viewSize']
          .getPropertyValue('width');
      clientHeight = await mpjs.context['engineScope']['viewSize']
          .getPropertyValue('height');
    } else {
      clientWidth = await mpjs.context['document']['body']
          .getPropertyValue('clientWidth');
      clientHeight = await mpjs.context['document']['body']
          .getPropertyValue('clientHeight');
    }
    final dynamic safeAreaTopHeight = await mpjs.context['document']['body']
        .getPropertyValue('windowPaddingTop');
    final dynamic safeAreaBottomHeight = await mpjs.context['document']['body']
        .getPropertyValue('windowPaddingBottom');
    final num devicePixelRatio =
        await mpjs.context.getPropertyValue('devicePixelRatio');
    DeviceInfo.physicalSizeWidth =
        clientWidth.toDouble() * devicePixelRatio.toDouble();
    DeviceInfo.physicalSizeHeight =
        clientHeight.toDouble() * devicePixelRatio.toDouble();
    DeviceInfo.devicePixelRatio = devicePixelRatio.toDouble();
    DeviceInfo.windowPadding = ui.MockWindowPadding(
      left: 0.0,
      top: safeAreaTopHeight is num ? safeAreaTopHeight.toDouble() : 0.0,
      right: 0.0,
      bottom:
          safeAreaBottomHeight is num ? safeAreaBottomHeight.toDouble() : 0.0,
    );
    DeviceInfo.deviceSizeChangeCallback?.call();
  }

  static void onGestureDetectorTrigger(Map message) {
    try {
      final widget = MPCore.findTargetHashCode(message['target'])?.widget;
      if (!(widget is GestureDetector)) return;
      if (message['event'] == 'onTap') {
        widget.onTap?.call();
      }
    } catch (e) {
      print(e);
    }
  }

  static void onOverlayTrigger(Map message) {
    try {
      final widget = MPCore.findTargetHashCode(message['target'])?.widget;
      if (!(widget is MPOverlayScaffold)) return;
      if (message['event'] == 'onBackgroundTap') {
        widget.onBackgroundTap?.call();
      }
    } catch (e) {
      print(e);
    }
  }

  static void onRichTextTrigger(Map message) {
    try {
      if (message['event'] == 'onTap') {
        final widget = MPCore.findTargetHashCode(message['target'])?.widget;
        if (!(widget is RichText)) return;
        final span = MPCore.findTargetTextSpanHashCode(
          message['subTarget'],
          element: widget.text,
        );
        if (span?.recognizer is TapGestureRecognizer) {
          (span?.recognizer as TapGestureRecognizer).onTap?.call();
        }
      } else if (message['event'] == 'onMeasured') {
        _onMeasuredText(message['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  static void onEditableTextTrigger(Map message) {
    try {
      final widget = MPCore.findTargetHashCode(message['target'])?.widget;
      if (!(widget is EditableText)) return;
      if (message['event'] == 'onSubmitted') {
        widget.onSubmitted?.call(message['data']);
      } else if (message['event'] == 'onChanged' && message['data'] is String) {
        widget.controller.text = message['data'];
        widget.controller.textDirty = false;
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

  static void onDecodeDrawable(Map message) {
    try {
      if (message['event'] == 'onDecode') {
        MPDrawable.receivedDecodedResult(message);
      } else if (message['event'] == 'onError') {
        MPDrawable.receivedDecodedError(message);
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
          MPNavigatorObserver.instance.navigator?.popUntil((route) =>
              route.isFirst ||
              route.hashCode == int.tryParse(message['toRouteId']));
        } else {
          if (MPNavigatorObserver.instance.navigator?.canPop() == true) {
            MPNavigatorObserver.instance.navigator?.pop();
          }
        }
        MPNavigatorObserver.doBacking = false;
      } else if (message['event'] == 'doPush') {
        MPNavigatorObserver.instance.navigator?.pushNamed(
          message['name'],
          arguments: message['arguments'],
        );
      } else if (message['event'] == 'doReplace') {
        MPNavigatorObserver.instance.navigator?.pushNamed(
          message['name'],
          arguments: message['arguments'],
        );
      } else if (message['event'] == 'doRestart') {
        MPNavigatorObserver.instance.navigator?.popUntil((route) => false);
        MPNavigatorObserver.instance.navigator?.pushNamed(
          message['name'],
          arguments: message['arguments'],
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static void onFragment(Map message) {
    try {
      if (message['event'] == 'init') {
        FragmentEventHub.instance.onInit(message['data']);
      } else if (message['event'] == 'update') {
        FragmentEventHub.instance.onUpdate(message['data']);
      } else if (message['event'] == 'dispose') {
        FragmentEventHub.instance.onDispose(message['data']);
      } else if (message['event'] == 'onMethodCallResult') {
        MPFragmentMethodChannel.receivedInvokeResponse(message['data']);
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
