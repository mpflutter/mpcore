import 'package:flutter/widgets.dart';

final List<GlobalKey> mainTabKeys = [];

class MPMainTab extends StatelessWidget {
  final Widget tabBar;
  final Widget body;

  MPMainTab({required this.tabBar, required this.body})
      : super(key: (() {
          mainTabKeys
              .removeWhere((element) => element.currentContext?.owner == null);
          final key = GlobalKey();
          mainTabKeys.add(key);
          return key;
        })());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: body),
        Container(key: Key('mainTabBar'), child: tabBar),
      ],
    );
  }
}
