part of gametime;

class GameInfoTab extends StatelessWidget {
  final GameModel game;

  GameInfoTab(this.game);

  Widget _getGenres(BuildContext context, GameModel game) {
    if (game.genres == null || game.genres.length == 0) {
      return new Container();
    }

    return new HorizontalChipList(
      list: game.genres,
      stringTransform: (g) => g.name,
    );
  }

  Widget _getVideoItem(BuildContext context, Video video) {
    return new InkWell(
          onTap: () async {
            String url = 'https://youtu.be/${video.videoId}';
            if (await canLaunch(url)) {
              await launch(url);
            }
            else {
              print('could not launch $url');
            }
          },
          child: new Stack(
          children: <Widget>[
            new Image.network(
            'https://img.youtube.com/vi/${video.videoId}/0.jpg',
              width: 150.0,
            ),
            new Container(
              height: 100.0,
              width: 150.0,
              color: new Color(0x77000000),
              child: new Icon(Icons.play_circle_outline, color: Colors.grey),
            )
          ]
        )
      );

  }



  Widget _getTrailersCard(BuildContext context, GameModel game) {
    if (game.videos == null || game.videos.length == 0) {
      return new Container();
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getHeaderText(context, 'Trailers'),
        new HorizontalScrollableMediaCard(
            height: 125.0,
            children: <Widget>[]..addAll(
                game.videos.map((v){
                  return new Container(
                    margin: EdgeInsets.all(5.0),
                    child: _getVideoItem(context, v),
                  );
                }).toList()
            )
        )
      ],
    );
  }

  Widget _getHeaderText(BuildContext context, String text) {
    return new Text(text, style: Theme.of(context).textTheme.headline,);
  }

  Widget _getActions(BuildContext context) {
    return new Row(
      children: <Widget>[
        new RaisedButton(
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
          onPressed: (){},
          child: new Row(
            children: <Widget>[
              new Icon(Icons.add),
              new Text('Add'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getSummary(BuildContext context) {
    if (game.summary == null) {
      return new Container();
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text('Summary', style: Theme.of(context).textTheme.headline,),
        new Card(
          elevation: 4.0,
          child: new Text(
            (game.summary ?? 'No description available.'),
            style: Theme.of(context).textTheme.body2,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //_getActions(context),
        new ReleaseDateChipList(game),
        _getGenres(context, game),
        _getSummary(context),
        new GameDetailScreenshotsCard(game: game),
        _getTrailersCard(context, game),
      ],
    );
  }
}