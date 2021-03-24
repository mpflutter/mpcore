part of '../mpcore.dart';

MPElement _encodeOverlay(Element scaffoldElement) {
  Element bodyElement;
  Color bodyBackgroundColor;
  if (scaffoldElement.widget is MPOverlayScaffold) {
    bodyElement = MPCore.findTarget<MPScaffoldBody>(scaffoldElement);
    bodyBackgroundColor =
        (scaffoldElement.widget as MPOverlayScaffold).backgroundColor;
  }
  return MPElement(
    hashCode: scaffoldElement.hashCode,
    name: 'overlay',
    children: MPElement.childrenFromFlutterElement(bodyElement),
    attributes: {
      'backgroundColor': bodyBackgroundColor?.value?.toString(),
      'onBackgroundTap': scaffoldElement.hashCode,
    },
  );
}
