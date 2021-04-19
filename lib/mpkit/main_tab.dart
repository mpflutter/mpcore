import 'package:flutter/widgets.dart';

class MPMainTab extends StatelessWidget {
  final Widget tabBar;
  final Widget body;

  MPMainTab({required this.tabBar, required this.body});

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
