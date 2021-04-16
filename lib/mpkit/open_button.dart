// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/widgets.dart';

class MPOpenButton extends StatelessWidget {
  final String openType;
  final Widget child;
  MPOpenButton({required this.openType, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
