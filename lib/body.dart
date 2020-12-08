part of 'mpcore.dart';

class MPTabBody extends StatefulWidget {
  final Widget header;
  final List<Tab> tabs;
  final List<Builder> children;

  MPTabBody({this.header, this.tabs, this.children});

  @override
  _MPTabBodyState createState() => _MPTabBodyState();
}

class _MPTabBodyState extends State<MPTabBody>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(() {
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
          TabBar(
            tabs: widget.tabs,
            controller: _tabController,
            labelColor: Colors.black,
          ),
          Expanded(
            key: Key('tab_body'),
            child: widget.children[_tabController.index],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          TabBar(
            tabs: widget.tabs,
            controller: _tabController,
            labelColor: Colors.black,
          ),
          Expanded(
            key: Key('tab_body'),
            child: widget.children[_tabController.index],
          ),
        ],
      );
    }
  }
}
