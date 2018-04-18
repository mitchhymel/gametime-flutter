part of gametime;

class QueryResult extends StatefulWidget {
  final Query query;

  QueryResult(this.query);

  @override
  _QueryResultState createState() => new _QueryResultState(this.query);
}

class _QueryResultState extends State<QueryResult> {
  final Query query;
  GameServiceClient _gameServiceClient;
  List<GameModel> _games;

  _QueryResultState(this.query) {
    _gameServiceClient = new GameServiceClient();
    _games = new List<GameModel>();
  }

  @override
  void initState() {
    super.initState();
    _fetchQuery().then((games) {
      setState(() {
        _games = games;
      });
    });
  }

  Future<List<GameModel>> _fetchQuery() async {
    return await _gameServiceClient.fetchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 6;
    return new InkWell(
      onLongPress: () => {},
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Text(query.name, style: Theme.of(context).textTheme.headline,),
            new Container(
              height: height,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[]
                  ..addAll(_games.map((game) => new GameImage(
                      game: game,
                      toDetail: true,
                      height: height,
                      width: height
                  ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}