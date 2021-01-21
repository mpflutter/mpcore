export 'network_defines.dart' if (dart.library.js) 'network_js.dart';

class Taro {
  static const bool isTaro = bool.fromEnvironment(
    'mpcore.env.taro',
    defaultValue: false,
  );
}
