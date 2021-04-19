part of 'mpcore.dart';

class MPTabController extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }

  MPTabController({int? initialIndex}) : _index = initialIndex ?? 0;
}

class MPTabBody extends StatefulWidget {
  final Widget? header;
  final MPTabController tabController;
  final Widget? tabBar;
  final List<Builder> children;

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
