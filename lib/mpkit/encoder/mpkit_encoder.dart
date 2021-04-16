library mpkit_encoder;

import 'package:mpcore/mpcore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/widgets.dart';

part './web_view.dart';
part './scaffold.dart';
part './page_view.dart';
part './video_view.dart';
part './main_tab.dart';
part './open_button.dart';

class MPKitEncoder {
  static MPElement? fromFlutterElement(Element element) {
    if (element.widget is MPWebView) {
      return _encodeMPWebView(element);
    } else if (element.widget is MPScaffold) {
      return _encodeMPScaffold(element);
    } else if (element.widget is MPPageView) {
      return _encodeMPPageView(element);
    } else if (element.widget is MPVideoView) {
      return _encodeMPVideoView(element);
    } else if (element.widget is MPMainTab) {
      return _encodeMPMainTab(element);
    } else if (element.widget is MPOpenButton) {
      return _encodeMPOpenButton(element);
    } else {
      return null;
    }
  }
}
