import 'package:flutter/widgets.dart';
import '../mpjs/mpjs.dart' as mpjs;

import '../mpcore.dart';

class MPAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Color backgroundColor;
  final double appBarHeight;

  MPAppBar({
    required this.context,
    this.leading,
    this.title,
    this.trailing,
    this.backgroundColor = Colors.white,
    this.appBarHeight = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: appBarHeight + MediaQuery.of(context).padding.top,
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: appBarHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      child: title ?? Container(),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _renderLeading(context),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: _renderTrailing(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderLeading(BuildContext context) {
    if (leading != null) {
      return leading!;
    } else {
      if (Navigator.of(context).canPop()) {
        return GestureDetector(
          onTap: () {
            if (Taro.isTaro) {
              mpjs.context['Taro'].callMethod('navigateBack');
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            width: 44,
            height: 44,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                child: Image.network(
                  'https://cdn.jsdelivr.net/gh/mpflutter-plugins/icons@master/arrow_back_ios_new_black_24dp.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ); //back button
      }
      return SizedBox();
    }
  }

  Widget _renderTrailing(BuildContext context) {
    if (Taro.isTaro) {
      return SizedBox(width: 120);
    } else if (trailing != null) {
      return trailing!;
    } else {
      return Container();
    }
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(appBarHeight + MediaQuery.of(context).padding.top);
}
