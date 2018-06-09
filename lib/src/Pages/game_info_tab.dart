part of gametime;

class GameInfoTab extends StatelessWidget {
  final GameModel game;

  GameInfoTab(this.game);

  Widget _getPlatforms(BuildContext context, GameModel game) {
    if (game.platforms == null || game.platforms.length == 0) {
      return new Container();
    }

    return new HorizontalChipList(game.platforms.map((p) => p.name).toList());
  }

  Widget _getGenres(BuildContext context, GameModel game) {
    if (game.genres == null || game.genres.length == 0) {
      return new Container();
    }

    return new HorizontalChipList(game.genres.map((g) => g.name).toList());
  }

  Widget _getReleaseDate(BuildContext context, GameModel game) {
    if (game.releaseDates == null || game.releaseDates.length == 0) {
      return new Container();
    }

    return new HorizontalChipList(game.releaseDates.map((r) =>
      '${DateTimeHelper.getMonthDayYear(r.date)} in ${r.region.name} on ${r.platform.name} ').toList()
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

  Widget _getScreenshotItem(BuildContext context, IGDBImage image) {
    Widget imageWidget = FadeInImage.assetNetwork(
      placeholder: AssetHelper.ImagePlaceholderPath,
      image: image.getImageUrl(IGDBImageSizes.HD720P),
      width: 200.0,
    );

    return new InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => new Center(
            child: new ImageCarousel(
              <ImageProvider>[
                new NetworkImage(image.getImageUrl(IGDBImageSizes.HD720P)),
              ],
              allowZoom: true,
            ),
          )
        );
//        Navigator.of(context).push(new MaterialPageRoute<Null>(
//            builder: (BuildContext context) {
//              return new Scaffold(
//                appBar: new AppBar(
//                  backgroundColor: Colors.transparent,
//                ),
//                backgroundColor: new Color(0x77000000),
//                body: new Center(
//                  child: new ImageCarousel(
//                    <ImageProvider>[
//                      new NetworkImage(image.getImageUrl(IGDBImageSizes.HD720P)),
//                    ],
//                    height: 150.0,
//                    allowZoom: true,
//                  ),
//                ),
//              );
//            }
//        ));
      },
      child: FadeInImage.assetNetwork(
        placeholder: AssetHelper.ImagePlaceholderPath,
        image: image.getImageUrl(IGDBImageSizes.HD720P),
        width: 200.0,
      ),
    );
  }

  Widget _getScreenshotsCard(BuildContext context, GameModel game) {
    if (game.screenshots == null || game.screenshots.length == 0) {
      return new Container();
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getHeaderText(context, 'Screenshots'),
        new HorizontalScrollableMediaCard(
          height: 125.0,
          children: <Widget>[]..addAll(
            game.screenshots.map((s){
              return new Container(
              margin: EdgeInsets.all(5.0),
              child: _getScreenshotItem(context, s),
              );
            }).toList()
          )
        )
      ],
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

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //_getActions(context),
        _getReleaseDate(context, game),
        _getGenres(context, game),
        _getHeaderText(context, 'Summary'),
        new Card(
          elevation: 4.0,
          child: new Text(
            (game.summary ?? "No description available."),
            style: Theme.of(context).textTheme.body2,
          ),
        ),
        new GameDetailScreenshotsCard(game: game),
        _getTrailersCard(context, game),
      ],
    );
  }
}