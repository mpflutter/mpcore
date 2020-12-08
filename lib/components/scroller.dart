part of '../mpcore.dart';

class ScrollToBottomNotifier extends ChangeNotifier {
  static final ScrollToBottomNotifier instance = ScrollToBottomNotifier();

  notify() {
    notifyListeners();
  }
}
