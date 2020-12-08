part of '../mpcore.dart';

_Element _encodeImage(Element element) {
  final widget = element.widget as Image;
  return _Element(
    name: 'image',
    attributes: {
      'src': (() {
        if (widget.image is NetworkImage) {
          return (widget.image as NetworkImage).url;
        }
      })(),
      'assetName': (() {
        if (widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName;
        }
      })(),
      'assetPkg': (() {
        if (widget.image is AssetImage) {
          return (widget.image as AssetImage).package;
        }
      })(),
      'fit': widget.fit.toString(),
      'width': widget.width,
      'height': widget.height,
    },
  );
}
