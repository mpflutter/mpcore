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
  final String initialRoute;
  final RouteFactory? onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;
  final double? maxWidth;

  MPApp({
    this.currentPackage,
    this.title,
    this.color,
    required this.routes,
    required this.initialRoute,
    this.onGenerateRoute,
    required this.navigatorObservers,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
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
        final routeMapSubPackages = MPCore.routeMapSubPackages;
        if (routeMapSubPackages != null) {
          var targetPackage = 'main';
          for (final key in routeMapSubPackages.keys) {
            if (settings.name?.startsWith(key) == true) {
              targetPackage = routeMapSubPackages[key] ?? 'main';
            }
          }
          if (targetPackage != currentPackage) {
            MPChannel.onSubPackageNavigate(targetPackage, settings.name ?? '');
            return MPPageRoute(
              builder: (context) => Container(),
              settings: RouteSettings(
                arguments: {'\$mpcore.package.prevent': true},
              ),
            );
          }
        }
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
        final routeName = initialRoute;
        final routeMapSubPackages = MPCore.routeMapSubPackages;
        if (routeMapSubPackages != null) {
          var targetPackage = 'main';

          for (final key in routeMapSubPackages.keys) {
            if (routeName.startsWith(key)) {
              targetPackage = routeMapSubPackages[key] ?? 'main';
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
