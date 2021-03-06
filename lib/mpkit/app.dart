import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';
import 'package:mpcore/channel/channel_io.dart'
    if (dart.library.js) 'package:mpcore/channel/channel_js.dart';

import 'page_route.dart';

class MPApp extends StatelessWidget {
  final String? currentPackage;
  final String? title;
  final Color? color;
  final Map<String, WidgetBuilder> routes;
  final RouteFactory? onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;
  final double? maxWidth;
  final bool fragmentMode;

  MPApp({
    this.currentPackage,
    this.title,
    this.color,
    required this.routes,
    this.onGenerateRoute,
    required this.navigatorObservers,
    this.maxWidth,
    this.fragmentMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (fragmentMode) {
      return _renderFragmentApp();
    } else {
      return _renderRegularApp();
    }
  }

  WidgetsApp _renderFragmentApp() {
    return WidgetsApp(
      title: title ?? '',
      color: color ?? Color(0),
      builder: (context, widget) {
        return widget ?? Container();
      },
      routes: routes,
      navigatorObservers: navigatorObservers,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return MPPageRoute<T>(settings: settings, builder: builder);
      },
      onGenerateRoute: (settings) {
        return onGenerateRoute?.call(settings) ??
            MPPageRoute(builder: (context) {
              final routeBuilder = routes[settings.name];
              if (routeBuilder != null) {
                return routeBuilder(context);
              } else {
                return Container();
              }
            });
      },
      onGenerateInitialRoutes: (_) {
        return [
          onGenerateRoute?.call(RouteSettings(name: '/')) ??
              MPPageRoute(builder: (context) => _FragmentGroup())
        ];
      },
    );
  }

  WidgetsApp _renderRegularApp() {
    return WidgetsApp(
      title: title ?? '',
      color: color ?? Color(0),
      builder: (context, widget) {
        return widget ?? Container();
      },
      routes: routes,
      navigatorObservers: navigatorObservers,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return MPPageRoute<T>(settings: settings, builder: builder);
      },
      onGenerateRoute: (settings) {
        return onGenerateRoute?.call(settings) ??
            MPPageRoute(builder: (context) {
              final routeBuilder = routes[settings.name];
              if (routeBuilder != null) {
                return routeBuilder(context);
              } else {
                return Container();
              }
            });
      },
      onGenerateInitialRoutes: (_) {
        final routeName = MPNavigatorObserver.instance.initialRoute;
        final routeParams = MPNavigatorObserver.instance.initialParams;
        return [
          onGenerateRoute?.call(
                  RouteSettings(name: routeName, arguments: routeParams)) ??
              MPPageRoute(builder: (context) {
                final routeBuilder = routes[routeName];
                if (routeBuilder != null) {
                  return routeBuilder(context);
                } else {
                  return Container();
                }
              })
        ];
      },
    );
  }
}

class FragmentEventHub {
  static final instance = FragmentEventHub();

  Function(Map params)? _initCallback;

  Function(Map params)? _updateCallback;

  Function(Map params)? _disposeCallback;

  void onInit(Map params) {
    _initCallback?.call(params);
  }

  void onUpdate(Map params) {
    _updateCallback?.call(params);
  }

  void onDispose(Map params) {
    _disposeCallback?.call(params);
  }
}

class _FragmentGroup extends StatefulWidget {
  @override
  __FragmentGroupState createState() => __FragmentGroupState();
}

class __FragmentGroupState extends State<_FragmentGroup> {
  final List<MPFragmentWidget> children = [];

  @override
  void initState() {
    super.initState();
    _listenEvents();
  }

  void _listenEvents() {
    FragmentEventHub.instance._initCallback = _onInit;
    FragmentEventHub.instance._updateCallback = _onUpdate;
    FragmentEventHub.instance._disposeCallback = _onDispose;
  }

  void _onInit(Map params) {
    final fragmentKey = params['key'] as String;
    final fragmentRoute = params['route'] as String;
    final fragmentParams = params['params'] as Map?;
    final fragmentSize = Size(
      (params['width'] as num).toDouble(),
      (params['height'] as num).toDouble(),
    );
    setState(() {
      children.add(
        MPFragmentWidget(
          key: Key(fragmentKey),
          route: fragmentRoute,
          params: fragmentParams,
          size: fragmentSize,
        ),
      );
    });
  }

  void _onUpdate(Map params) {
    final fragmentKey = params['key'] as String;
    final fragmentRoute = params['route'] as String;
    final fragmentParams = params['params'] as Map?;
    final fragmentSize = Size(
      (params['width'] as num).toDouble(),
      (params['height'] as num).toDouble(),
    );
    final targetIndex = children.indexWhere((element) {
      final key = element.key;
      if (key is ValueKey && key.value == fragmentKey) {
        return true;
      }
      return false;
    });
    if (targetIndex >= 0) {
      setState(() {
        children[targetIndex] = MPFragmentWidget(
          key: Key(fragmentKey),
          route: fragmentRoute,
          params: fragmentParams,
          size: fragmentSize,
        );
      });
    }
  }

  void _onDispose(Map params) {
    final fragmentKey = params['key'] as String;
    setState(() {
      children
        ..removeWhere(
          (element) =>
              element.key is ValueKey &&
              (element.key as ValueKey).value == fragmentKey,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MPScaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: children),
      ),
      isFragmentMode: true,
      isListBody: false,
    );
  }
}

class MPFragmentMethodChannel {
  static Map<String, Completer> handlers = {};

  final BuildContext context;

  MPFragmentMethodChannel(this.context);

  Future<dynamic> invoke(String method, [Map? params]) async {
    final fragmentWidget =
        context.findAncestorWidgetOfExactType<MPFragmentWidget>();
    if (fragmentWidget == null) return;
    final fragmentKey = (fragmentWidget.key as ValueKey).value as String;
    final completer = Completer();
    final requestId = Random().nextDouble().toString();
    handlers[requestId] = completer;
    MPChannel.postMesssage(
      json.encode({
        'type': 'fragment',
        'message': {
          'event': 'onMethodCall',
          'data': {
            'key': fragmentKey,
            'requestId': requestId,
            'method': method,
            'params': params ?? {},
          },
        },
      }),
      forLastConnection: true,
    );
    return completer.future;
  }

  static void receivedInvokeResponse(Map message) {
    if (!(message is Map)) return;
    if (message['requestId'] != null) {
      final String requestId = message['requestId'];
      handlers[requestId]?.complete(message['result']);
      handlers.remove(requestId);
    }
  }
}

class MPFragmentWidget extends StatefulWidget {
  final String route;
  final Map? params;
  final Size size;

  MPFragmentWidget({
    required Key key,
    required this.route,
    required this.params,
    required this.size,
  }) : super(key: key);

  static Map getParams(BuildContext context) {
    return context.findAncestorWidgetOfExactType<MPFragmentWidget>()?.params ??
        {};
  }

  static Future<dynamic> invokeMethod(BuildContext context, String method,
      [Map? params]) {
    return MPFragmentMethodChannel(context).invoke(method, params);
  }

  @override
  _MPFragmentWidgetState createState() => _MPFragmentWidgetState();
}

class _MPFragmentWidgetState extends State<MPFragmentWidget> {
  Widget? child;

  @override
  void initState() {
    super.initState();
    _buildChild();
  }

  @override
  void didUpdateWidget(covariant MPFragmentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _buildChild();
    });
  }

  void _buildChild() {
    final app = context.findAncestorWidgetOfExactType<WidgetsApp>();
    if (app != null) {
      final pageRoute = app.onGenerateRoute?.call(
        RouteSettings(name: widget.route),
      );
      if (pageRoute is PageRoute) {
        child = pageRoute.buildPage(
          context,
          AlwaysStoppedAnimation(0.0),
          AlwaysStoppedAnimation(0.0),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(
        size: widget.size,
        padding: EdgeInsets.zero,
      ),
      child: Positioned(
        left: 0,
        top: 0,
        width: widget.size.width,
        height: widget.size.height,
        child: child ?? Container(),
      ),
    );
  }
}
