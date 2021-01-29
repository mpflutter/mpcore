library mpkit_encoder;

import 'package:mpcore/mpcore.dart';

part './web_view.dart';
part './scaffold.dart';
part './page_view.dart';
part './video_view.dart';

class MPKitEncoder {
  static MPElement fromFlutterElement(Element element) {
    if (element.widget is MPWebView) {
      return _encodeMPWebView(element);
    } else if (element.widget is MPScaffold) {
      return _encodeMPScaffold(element);
    } else if (element.widget is MPPageView) {
      return _encodeMPPageView(element);
    } else if (element.widget is MPVideoView) {
      return _encodeMPVideoView(element);
    } else {
      return null;
    }
  }
}
