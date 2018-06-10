part of gametime;

typedef Future<List<T>> PageRequest<T> (int page, int pageSize);
typedef Widget WidgetAdapter<T>(T t);

class PaginatedInfiniteScrollView<T> extends StatefulWidget {

  final PageRequest<T> pageRequest;
  final WidgetAdapter<T> widgetAdapter;
  final int pageSize;
  final int pageThreshold;
  final int maxLimit;

  PaginatedInfiniteScrollView({
    @required this.pageRequest,
    @required this.widgetAdapter,
    this.pageSize=50,
    this.pageThreshold=1,
    this.maxLimit=200,
  });


  @override
  State createState() => new _PaginatedInfiniteScrollViewState<T>();
}

class _PaginatedInfiniteScrollViewState<T> extends State<PaginatedInfiniteScrollView<T>> {

  List<T> items = [];
  Future request;

  @override
  void initState() {
    super.initState();
    this.lockedLoadNext();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future loadNext() async {
    int page = (items.length / widget.pageSize).floor();
    List<T> fetched = await widget.pageRequest(page, widget.pageSize);
    if (mounted) {
      this.setState(() {
//        debugPrint(fetched.length.toString());
//        fetched.removeWhere((e) => items.contains(e));
//        debugPrint(fetched.length.toString());
        items.addAll(fetched);
      });
    }
  }

  void lockedLoadNext() {
    if (this.request == null) {
      this.request = loadNext().then((x){
        this.request = null;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: this.request != null ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<Null> onRefresh() async {
    this.request?.timeout(const Duration());
    setState((){
      items = [];
    });
    List<T> fetched = await widget.pageRequest(0, widget.pageSize);
    setState(() {
      items = fetched;
    });
  }

  Widget itemBuilder(BuildContext context, int index) {
    if (items.length < widget.maxLimit && index + widget.pageThreshold >= items.length) {
      lockedLoadNext();
      return _buildProgressIndicator();
    }

    return widget.widgetAdapter(items[index]);
  }

  @override
  Widget build(BuildContext context) {
    ListView listView = new ListView.builder(
      itemCount: items.length,
      itemBuilder: itemBuilder,
    );

    return new RefreshIndicator(
        child: listView,
        onRefresh: onRefresh,
    );
  }
}