part of gametime;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  bool _isSearching = false;
  GameServiceClient _gameServiceClient;
  List<GameModel> _games;
  
  _SearchPageState() {
    _isSearching = false;
    _games = new List<GameModel>();
    _gameServiceClient = new GameServiceClient();
  }

   _onSubmitted(String value) async {
    setState(() {
      _isSearching = true;
      _games = new List<GameModel>();
    });

    var response = await _gameServiceClient.searchGames(value);

    setState(() {
      _games = response;
      _isSearching = false;
    });
  }

  onTap(GameModel result) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new DetailsPage(
            game: result,
          );
        }
    ));
  }

  Widget buildResult(BuildContext context, GameModel result) {
    return new Card(
        child: new InkWell(
          onTap: () => onTap(result),
          child: new Row(
            children: <Widget>[
              new GameImage(
                width: 100.0,
                height: 100.0,
                game: result,
                heroTag: result.id,
              ),
              new Flexible(
                child: new Column(
                  children: <Widget>[
                    new Text(result.name),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Widget buildBody(BuildContext context) {
    return _isSearching ?
        new Center(child: new CircularProgressIndicator())
        :
        new Column(
              children: <Widget>[
                new Expanded(
                    child: new ListView.builder(
                      itemBuilder: (context, index) => buildResult(context, _games[index]),
                      itemCount: _games.length,
                    )
                )
              ]
          );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new TextField(
          autofocus: true,
          onSubmitted: _onSubmitted,
          style: Theme.of(context).textTheme.title
        )
      ),
      body: buildBody(context)
    );
  }
}