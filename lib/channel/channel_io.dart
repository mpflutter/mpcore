import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;

import '../mpcore.dart';

import 'channel_base.dart';
import 'package:path/path.dart' as path;
import '../hot_reloader.dart';
import 'package:mime_type/mime_type.dart';

class MPChannel {
  static bool _serverSetupped = false;
  static HttpServer server;
  static List<WebSocket> sockets = [];
  static String lastMessage;

  static Future setupHotReload(MPCore minip) async {
    if (HotReloader.isHotReloadable) {
      var info = await dev.Service.getInfo();
      var uri = info.serverUri;
      uri = uri.replace(path: path.join(uri.path, 'ws'));
      if (uri.scheme == 'https') {
        uri = uri.replace(scheme: 'wss');
      } else {
        uri = uri.replace(scheme: 'ws');
      }
      print('Hot reloading enabled');
      final reloader = HotReloader(vmServiceUrl: uri.toString());
      reloader.addPath("./lib");
      reloader.addPath("./common");
      reloader.onReload.listen((event) async {
        await minip.handleHotReload();
        print("Reloaded");
      });
      await reloader.go();
    }
    setupWebServer();
  }

  static void setupWebServer() async {
    if (_serverSetupped) {
      return;
    }
    _serverSetupped = true;
    try {
      server = await HttpServer.bind('0.0.0.0', 8888, shared: false);
      print("Listening 0.0.0.0:8888");
      await for (var req in server) {
        if (req.uri.path == '/') {
          final socket = await WebSocketTransformer.upgrade(req);
          sockets.add(socket);
          if (lastMessage != null) {
            socket.add(lastMessage);
          }
          socket.listen(handleClientMessage);
        } else if (req.uri.path.startsWith("/assets/packages/")) {
          handlePackageAssetsRequest(req);
        } else if (req.uri.path.startsWith("/assets/")) {
          handleAssetsRequest(req);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static void handlePackageAssetsRequest(HttpRequest request) {
    final pkgName =
        request.uri.path.split('/assets/packages/')[1].split('/')[0];
    final pkgPath = findPackagePath(pkgName);
    if (pkgPath == null) {
      request.response
        ..statusCode = 404
        ..close();
      return;
    }
    final fileComponents =
        request.uri.path.split('/assets/packages/')[1].split('/');
    if (fileComponents[1] == 'assets' && fileComponents[2] == 'assets') {
      fileComponents.removeRange(0, 2);
    } else if (fileComponents[1] == 'assets') {
      fileComponents.removeRange(0, 1);
    }

    final fileName = fileComponents.join('/');
    String mimeType = mime(fileName);
    if (mimeType == null) {
      mimeType = 'text/plain; charset=UTF-8';
    }
    request.response.headers
      ..set(
        'Access-Control-Allow-Origin',
        '*',
      )
      ..set(
        'Content-Type',
        mimeType,
      );
    if (File('$pkgPath/$fileName').existsSync()) {
      request.response
        ..statusCode = 200
        ..add(File('$pkgPath/$fileName').readAsBytesSync())
        ..close();
    } else {
      request.response
        ..statusCode = 404
        ..close();
    }
  }

  static String findPackagePath(String pkgName) {
    final lines = File('./.packages').readAsLinesSync();
    for (final line in lines) {
      if (line.startsWith('$pkgName:')) {
        return line
            .replaceFirst('$pkgName:', '')
            .replaceFirst('file://', '')
            .replaceFirst('/lib/', '');
      }
    }
    return null;
  }

  static void handleAssetsRequest(HttpRequest request) {
    final fileName = request.uri.path.replaceFirst('/assets/', '');
    String mimeType = mime(fileName);
    if (mimeType == null) {
      mimeType = 'text/plain; charset=UTF-8';
    }
    request.response.headers
      ..set(
        'Access-Control-Allow-Origin',
        '*',
      )
      ..set(
        'Content-Type',
        mimeType,
      );
    if (File(fileName).existsSync()) {
      request.response
        ..statusCode = 200
        ..add(File(fileName).readAsBytesSync())
        ..close();
    } else if (File("./build/web/assets/$fileName").existsSync()) {
      request.response
        ..statusCode = 200
        ..add(File("./build/web/assets/$fileName").readAsBytesSync())
        ..close();
    } else {
      request.response
        ..statusCode = 404
        ..close();
    }
  }

  static void handleClientMessage(msg) {
    final obj = json.decode(msg);
    if (obj['type'] == 'gesture_detector') {
      MPChannelBase.onGestureDetectorTrigger(obj['message']);
    } else if (obj['type'] == 'tab_bar') {
      MPChannelBase.onTabBarTrigger(obj['message']);
    } else if (obj['type'] == 'scroller') {
      MPChannelBase.onScrollerTrigger(obj['message']);
    } else if (obj['type'] == 'router') {
      MPChannelBase.onRouterTrigger(obj['message']);
    }
  }

  static void postMesssage(String message) {
    if (message == null) return;
    for (var socket in sockets) {
      try {
        socket.add(message);
      } catch (e) {}
    }
    lastMessage = message;
    // print(message);
  }

  static String getInitialRoute() {
    return '/';
  }
}
