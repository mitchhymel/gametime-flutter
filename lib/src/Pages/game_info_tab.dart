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
    '${r.human} in ${r.region.name} for ${r.platform.name} ').toList());
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getReleaseDate(context, game),
        _getPlatforms(context, game),
        _getGenres(context, game),
        new Card(
          elevation: 4.0,
          child: new Text(
            (game.summary ?? "No description available."),
            style: Theme.of(context).textTheme.body2,
          ),
        ),
        new Card(
          elevation: 4.0,
          child: new Text(
            'Fan Rating: ${game.fanRating}',
            style: Theme.of(context).textTheme.body2,
          )
        ),
        new Card(
            elevation: 4.0,
            child: new Text(
              'Critic Rating: ${game.criticRating}',
              style: Theme.of(context).textTheme.body2,
            )
        ),
        new Card(
            elevation: 4.0,
            child: new Text(
              'Popularity: ${game.popularity}',
              style: Theme.of(context).textTheme.body2,
            )
        ),
        new InkWell(
          onTap: () async {
            String url = 'https://youtu.be/${game.videos.first.videoId}';
            if (await canLaunch(url)) {
              await launch(url);
            }
            else {
              print('could not launch $url');
            }
          },
          child: new Image.network(
            'https://img.youtube.com/vi/${game.videos.first.videoId}/0.jpg',
            height: 100.0,
            width: 100.0,
          ),
        )
      ],
    );
  }
}