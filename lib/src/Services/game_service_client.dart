part of gametime;

class GameServiceClient extends IGDBClient {

  static final GameServiceClient _singleton = new GameServiceClient._internal();
  factory GameServiceClient() {
    return _singleton;
  }

  GameServiceClient._internal() : super(
      MY_USER_AGENT,
      IGDB_API_URL,
      MY_API_KEY
  );

  static const List<String> fields = const [
    'name',
    'url',
    'id',
    'summary',
    'cover.cloudinary_id',
    'genres',
    'platforms',
    'release_dates',
    'popularity',
    'rating',
    'rating_count',
    'aggregated_rating',
    'aggregated_rating_count',
    'screenshots',
    'videos',
  ];

  Future<List<ReleaseDate>> getUpcomingReleases() async {
    String timeNow = new DateTime.now()
        .millisecondsSinceEpoch
        .toString();

    String time21DaysFromNow = new DateTime.now()
        .add(new Duration(days: 30))
        .millisecondsSinceEpoch
        .toString();

    List resp = await releaseDates(
      new RequestParameters(
        filters: [
          new Filter('date', FilterOperator.GREATER_THAN, timeNow),
          new Filter('date', FilterOperator.LESS_THAN, time21DaysFromNow),
          new Filter('region', FilterOperator.EQUAL, Regions.NORTH_AMERICA.id),
        ],
        expand: 'game',
        limit: 30,
        order: 'date:asc'
      )
    );

    List<ReleaseDate> result = new List<ReleaseDate>();
    resp.forEach((date) {
      result.add(ReleaseDate.fromMap(date, expandGame: true));
    });
    return result;
  }

  Future<List<GameModel>> searchGames(String value) async {
    List result = await games(new RequestParameters(
        search: value,
        fields: fields
    ));
    return _convertIgdbMapListToGameModelList(result);
  }

  Future<List<GameModel>> fetchGames(List<int> ids) async {
    List<dynamic> result = await games(new RequestParameters(
      ids: ids.map((id) => id.toString()).toList(),
      fields: fields,
      limit: 20
    ));
    print(result);
    return _convertIgdbMapListToGameModelList(result);
  }

  List<GameModel> _convertIgdbMapListToGameModelList(List<dynamic> list) {
    List<Game> igdbGames = Game.listFromMapList(list);
    return igdbGames.map((g) => GameModel.fromIGDBGame(g)).toList();
  }

  Future<List<GameModel>> fetchQuery(Query query) async {
    List result = await requestByEndpoint(query.endpoint, query.params);
    return _convertIgdbMapListToGameModelList(result);
  }


}