import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';
import 'package:mpcore/channel/channel_io.dart'
    if (dart.library.js) 'package:mpcore/channel/channel_js.dart';

import 'page_route.dart';

class MPApp extends StatelessWidget {
  final String currentPackage;
  final String title;
  final Color color;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;

  MPApp({
    this.currentPackage,
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
      onGenerateRoute: (settings) {
        if (MPCore.routeMapSubPackages != null) {
          String targetPackage = 'main';
          for (final key in MPCore.routeMapSubPackages.keys) {
            if (settings.name.startsWith(key)) {
              targetPackage = MPCore.routeMapSubPackages[key];
            }
          }
          if (targetPackage != currentPackage) {
            MPChannel.onSubPackageNavigate(targetPackage, settings.name);
            return MPPageRoute(
              builder: (context) => Container(),
              settings: RouteSettings(
                arguments: {'\$mpcore.package.prevent': true},
              ),
            );
          }
        }
        return onGenerateRoute?.call(settings) ??
            MPPageRoute(builder: (context) => routes[settings.name](context));
      },
      onGenerateInitialRoutes: (_) {
        final routeName = initialRoute ?? '/';
        if (MPCore.routeMapSubPackages != null) {
          String targetPackage = 'main';
          for (final key in MPCore.routeMapSubPackages.keys) {
            if (routeName.startsWith(key)) {
              targetPackage = MPCore.routeMapSubPackages[key];
            }
          }
          if (targetPackage != currentPackage) {
            MPChannel.onSubPackageNavigate(targetPackage, routeName);
            return [
              MPPageRoute(
                builder: (context) => Container(),
                settings: RouteSettings(
                  arguments: {'\$mpcore.package.prevent': true},
                ),
              )
            ];
          }
        }
        return [
          onGenerateRoute?.call(RouteSettings(name: routeName)) ??
              MPPageRoute(builder: (context) => routes[routeName](context))
        ];
      },
    );
  }
}
