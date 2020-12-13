part of 'mpcore.dart';

class MPTabBody extends StatefulWidget {
  final Widget header;
  final TabController tabController;
  final Widget tabBar;
  final List<Builder> children;

  MPTabBody({
    this.header,
    this.tabController,
    this.tabBar,
    this.children,
  });

  @override
  _MPTabBodyState createState() => _MPTabBodyState();
}

class _MPTabBodyState extends State<MPTabBody>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.header != null) {
      return Column(
        children: [
          Container(
            key: Key('tab_header'),
            child: widget.header,
          ),
          Container(
            key: Key('tab_bar'),
            child: widget.tabBar,
          ),
          Expanded(
            key: Key('tab_body'),
            child: widget.children[widget.tabController.index],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            key: Key('tab_bar'),
            child: widget.tabBar,
          ),
          Expanded(
            key: Key('tab_body'),
            child: widget.children[widget.tabController.index],
          ),
        ],
      );
    }
  }
}
