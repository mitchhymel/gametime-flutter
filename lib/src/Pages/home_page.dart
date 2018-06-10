part of gametime;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<ReleaseDate> releaseDates;

  _HomePageState() {
    releaseDates = new List<ReleaseDate>();
  }

  Future<List<ReleaseDate>> _fetchData() async {
    GameServiceClient client = new GameServiceClient();
    List<ReleaseDate> resp = await client.getUpcomingReleases();
    return resp;
  }

  @override
  void initState() {
    super.initState();
    _fetchData().then((list) {
      if (this.mounted) {
        setState((){
          releaseDates = list;
        });
      }
    });
  }

  Widget _getHeader(BuildContext context, int index) {
    ReleaseDate date = releaseDates[index];
    return new Container(
      width: 40.0,
      child: new Column(
        children: <Widget>[
          new Text('${date.date.month}/', style:Theme.of(context).textTheme.headline),
          new Text('${date.date.day}', style:Theme.of(context).textTheme.headline)
        ],
      ),
    );
  }

  Widget _getItem(BuildContext context, int index) {
    ReleaseDate date = releaseDates[index];
    GameModel model = GameModel.fromIGDBGame(date.gameExpanded);
    return new Card(
      child: new Row(
        children: <Widget>[
          new GameImage(
            game: model,
            height: 100.0,
            width: 100.0,
            source: 'homepage',
          ),
          new Flexible(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(model.name, style: Theme.of(context).textTheme.title,),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new HorizontalChipList(
                        list: model.genres,
                        stringTransform: (g) => g.name,
                      ),
                      new Text(date.platform.name, style: Theme.of(context).textTheme.caption)
                    ],
                  )
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: releaseDates.length == 0 ? new Container() :
        new SideHeaderListView(
            itemCount: releaseDates.length,
            itemExtend: 140.0,
            headerBuilder: _getHeader,
            itemBuilder: _getItem,
            hasSameHeader: (a, b) {
              return releaseDates[a].human.compareTo(releaseDates[b].human) == 0;
            }
        )
    );
  }
}