import 'package:mpcore/mpjs/mpjs.dart' as mpjs;

class Taro {
  static bool? isTaroValue;

  static Future<bool> isTaro() async {
    isTaroValue ??= await mpjs.context.hasProperty('Taro');
    return isTaroValue!;
  }
}
