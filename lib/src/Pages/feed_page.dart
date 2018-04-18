part of gametime;

class FeedPageViewModel {

  final Map<String, GameModel> games;
  final List<Query> queries;

  FeedPageViewModel({this.games, this.queries});

  static FeedPageViewModel fromStore(Store<AppState> store) {

    return new FeedPageViewModel(
      games: store.state.games,
      queries: store.state.queries
    );
  }
}

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => new _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  _FeedPageState();

  @override
  void initState() {
    super.initState();
  }


  Widget _getFeed(BuildContext context, List<Query> queries) {
    return new Column(
      children: <Widget>[]
      ..addAll(queries.map((q) => new QueryResult(q))),
    );
  }

  _onClick(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new EditQueryPage();
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FeedPageViewModel>(
      converter: FeedPageViewModel.fromStore,
      builder: (context, viewModel){
        return new Scaffold(
          body: new Stack(
            children: <Widget>[
              new ListView(
                children: <Widget>[
                  _getFeed(context, viewModel.queries),
                ],
              ),
              new Container(
                alignment: new FractionalOffset(1.0, 1.0),
                padding: new EdgeInsets.all(10.0),
                child: new FloatingActionButton(
                  onPressed: () => _onClick(context),
                  child: new Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}