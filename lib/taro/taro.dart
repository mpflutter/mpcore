class Taro {
  static const bool isTaro = bool.fromEnvironment(
    'mpcore.env.taro',
    defaultValue: false,
  );
}
