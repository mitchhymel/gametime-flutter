part of gametime;

class GameImage extends StatelessWidget {
  final GameModel game;

  final BoxFit fit;
  final double width;
  final double height;
  final Alignment alignment;
  final bool toDetail;
  final String heroTag;
  final String source;

  GameImage({
    @required this.game,
    this.fit = BoxFit.fill,
    this.width = 80.0,
    this.height = 80.0,
    this.alignment = Alignment.center,
    this.toDetail = true,
    this.heroTag,
    this.source='',
  });

  final String placeholderPath = 'assets/img/placeholder.png';

  _onTap(BuildContext context, GameModel result) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new DetailsPage(
            game: result,
            source: this.source,
          );
        }
    ));
  }

  Widget _getImage() {
    Widget child;
    if (game.imageUrl == null) {
      child = new Image.asset(
        placeholderPath,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
      );
    }
    else {
      child = new FadeInImage.assetNetwork(
        placeholder: placeholderPath,
        image: game.imageUrl,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
      );
    }

    if (heroTag != null) {
      return new Hero(
        tag: heroTag,
        child: child
      );
    }
    else if (source != null){
      return new Hero(
        tag: game.id + source,
        child: child,
      );
    }
    else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: toDetail ? () => _onTap(context, game) : () {},
        child: _getImage()
    );
  }
}