part of 'mpcore.dart';

class MPTabController extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }

  int length;

  MPTabController({int? initialIndex, this.length = 0})
      : _index = initialIndex ?? 0;
}

class MPTabBody extends StatefulWidget {
  final Widget? header;
  final headerKey = GlobalKey();
  final MPTabController tabController;
  final Widget? tabBar;
  final tabBarKey = GlobalKey();
  final List<Builder> children;
  final tabBodyKey = GlobalKey();

  MPTabBody({
    this.header,
    required this.tabController,
    this.tabBar,
    required this.children,
  });

  @override
  _MPTabBodyState createState() => _MPTabBodyState();
}

class _MPTabBodyState extends State<MPTabBody>
    with SingleTickerProviderStateMixin<MPTabBody> {
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
            key: widget.headerKey,
            child: widget.header,
          ),
          Container(
            key: widget.tabBarKey,
            child: widget.tabBar,
          ),
          Expanded(
            key: widget.tabBodyKey,
            child: widget.children[widget.tabController.index],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            key: widget.tabBarKey,
            child: widget.tabBar,
          ),
          Expanded(
            key: widget.tabBodyKey,
            child: widget.children[widget.tabController.index],
          ),
        ],
      );
    }
  }
}
