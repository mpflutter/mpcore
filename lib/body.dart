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

// ignore: must_be_immutable
class MPTabBody extends StatefulWidget {
  final Widget? header;
  GlobalKey? headerKey;
  final MPTabController tabController;
  final Widget? tabBar;
  GlobalKey? tabBarKey;
  final List<Builder> children;
  GlobalKey? tabBodyKey;

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
  final headerKey = GlobalKey();
  final tabBarKey = GlobalKey();
  final tabBodyKey = GlobalKey();
  bool switching = false;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() async {
        switching = true;
        await Future.delayed(Duration(milliseconds: 100));
        setState(() {
          switching = false;
        });
      });
    });
  }

  @override
  void didUpdateWidget(covariant MPTabBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.headerKey = headerKey;
    widget.tabBarKey = tabBarKey;
    widget.tabBodyKey = tabBodyKey;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.headerKey = headerKey;
    widget.tabBarKey = tabBarKey;
    widget.tabBodyKey = tabBodyKey;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.header != null) {
      return Column(
        children: [
          Container(
            key: headerKey,
            child: widget.header,
          ),
          Container(
            key: tabBarKey,
            child: widget.tabBar,
          ),
          Expanded(
            key: tabBodyKey,
            child: switching
                ? Container()
                : widget.children[widget.tabController.index],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            key: tabBarKey,
            child: widget.tabBar,
          ),
          Expanded(
            key: tabBodyKey,
            child: switching
                ? Container()
                : widget.children[widget.tabController.index],
          ),
        ],
      );
    }
  }
}
