part of gametime;

class GameDetailScreenshotsCard extends StatefulWidget {
  final GameModel game;

  GameDetailScreenshotsCard({@required this.game});

  @override
  State createState() => new _GameDetailScreenshotsCardState();
}


class _GameDetailScreenshotsCardState extends State<GameDetailScreenshotsCard> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        vsync: this,
        length: widget.game.screenshots.length
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getHeaderText(BuildContext context, String text) {
    return new Text(text, style: Theme.of(context).textTheme.headline,);
  }

  Widget _getScreenshotItem(BuildContext context, IGDBImage image) {
    return new InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => new Center(
              child: new ImageCarousel(
                <ImageProvider>[]..addAll(
                  widget.game.screenshots.map((i) =>  new NetworkImage(i.getImageUrl(IGDBImageSizes.HD720P))
                )),
                allowZoom: false,
                fit: BoxFit.fitHeight,
              ),
            )
        );
      },
      child: FadeInImage.assetNetwork(
        placeholder: AssetHelper.ImagePlaceholderPath,
        image: image.getImageUrl(IGDBImageSizes.HD720P),
        width: 200.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.game.screenshots == null || widget.game.screenshots.length == 0) {
      return new Container();
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getHeaderText(context, 'Screenshots'),
        new HorizontalScrollableMediaCard(
            height: 125.0,
            children: <Widget>[]..addAll(
                widget.game.screenshots.map((s){
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
}