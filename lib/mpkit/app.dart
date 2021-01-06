import 'package:flutter/widgets.dart';

import 'page_route.dart';

class MPApp extends StatelessWidget {
  final String title;
  final Color color;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;

  MPApp({
    this.title,
    this.color,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.navigatorObservers,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: title,
      color: color,
      builder: (context, widget) {
        return widget;
      },
      routes: routes,
      navigatorObservers: navigatorObservers,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return MPPageRoute<T>(settings: settings, builder: builder);
      },
      onGenerateRoute: (settings) =>
          onGenerateRoute?.call(settings) ??
          MPPageRoute(builder: (context) => routes[settings.name](context)),
      onGenerateInitialRoutes: (_) {
        return [
          onGenerateRoute?.call(RouteSettings(name: initialRoute ?? '/')) ??
              MPPageRoute(
                  builder: (context) => routes[(initialRoute ?? '/')](context))
        ];
      },
    );
  }
}
