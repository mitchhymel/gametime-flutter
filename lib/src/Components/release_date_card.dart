part of gametime;

class ReleaseDateCard extends StatelessWidget {
  final ReleaseDate date;

  ReleaseDateCard({@required this.date});

  @override
  Widget build(BuildContext context) {
    GameModel model = GameModel.fromIGDBGame(date.gameExpanded);
    return new Card(
      child: new Row(
        children: <Widget>[
          new GameImage(
            game: model,
            height: 100.0,
            width: 100.0,
            source: 'homepage${date.id}',
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
                          new Text('${DateTimeHelper.getMonthDay(date.date)} on ${date.platform.name}', style: Theme.of(context).textTheme.caption)
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
}