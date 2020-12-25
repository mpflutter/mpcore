import 'package:flutter/widgets.dart';

class MPScaffold extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final bool isListBody;

  MPScaffold({this.body, this.backgroundColor, this.isListBody});

  @override
  Widget build(BuildContext context) {
    return body;
  }
}
