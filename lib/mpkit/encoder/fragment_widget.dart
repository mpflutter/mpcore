part of './mpkit_encoder.dart';

MPElement _encodeMPFragmentWidget(Element element) {
  final widget = element.widget as MPFragmentWidget;
  return MPElement(
    hashCode: element.hashCode,
    flutterElement: element,
    name: 'mp_fragment_widget',
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {
      'key': (widget.key as ValueKey).value,
    },
  );
}
