import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:mpcore/mpkit/mpkit.dart';

class SliverWaterfallDelegate
    extends SliverGridDelegateWithFixedCrossAxisCount {
  const SliverWaterfallDelegate({
    int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
  }) : super(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: 1.0,
        );
}

class SliverWaterfallItem extends StatelessWidget {
  final Widget child;
  final Size size;

  SliverWaterfallItem({this.child, this.size});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
