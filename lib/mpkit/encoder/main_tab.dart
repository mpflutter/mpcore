part of 'mpkit_encoder.dart';

MPElement _encodeMPMainTab(Element element) {
  return MPElement(
    name: 'mp_main_tab',
    // ignore: invalid_use_of_protected_member
    constraints: element.findRenderObject()?.constraints,
    children: MPElement.childrenFromFlutterElement(element),
    attributes: {},
  );
}
