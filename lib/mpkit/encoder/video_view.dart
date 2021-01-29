part of './mpkit_encoder.dart';

MPElement _encodeMPVideoView(Element element) {
  final widget = element.widget as MPVideoView;
  return MPElement(
    name: 'mp_video_view',
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'url': widget.url,
    },
  );
}
