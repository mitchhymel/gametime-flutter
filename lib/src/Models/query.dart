part of gametime;

class Query {
  final String name;
  final RequestParameters params;
  final Endpoints endpoint;

  Query({@required this.name, @required this.params, @required this.endpoint});

  static List<Query> getDefault() {
    return [
      //_getGamesReleasedTodayQuery(),
//      _getRPGsComingSoonPlatform(Platforms.SWITCH),
//      _getRPGsComingSoonPlatform(Platforms.NINTENDO_3DS),
//      _getRPGsComingSoonPlatform(Platforms.PLAYSTATION_VITA),
//      _getRPGsComingSoonPlatform(Platforms.PLAYSTATION_4),
//      _getRPGsComingSoonPlatform(Platforms.XBOX_ONE)
    ];
  }

  static Query _getRPGsComingSoonPlatform(Platforms platform) {
    String timeNow = new DateTime.now()
        .millisecondsSinceEpoch
        .toString();

    String time21DaysFromNow = new DateTime.now()
        .add(new Duration(days: 30))
        .millisecondsSinceEpoch
        .toString();

    return new Query(
        endpoint: Endpoints.GAMES,
        name: 'RPGs Coming Soon: ${platform.name}',
        params: new RequestParameters(
            fields: GameServiceClient.fields,
            filters: [
              new Filter('genres', FilterOperator.EQUAL, Genres.ROLE_PLAYING_GAME.id),
              new Filter('release_dates.platform', FilterOperator.EQUAL, platform.id),
              new Filter('release_dates.region', FilterOperator.EQUAL, Regions.NORTH_AMERICA.id),
              new Filter('release_dates.date', FilterOperator.GREATER_THAN, timeNow),
              new Filter('release_dates.date', FilterOperator.LESS_THAN, time21DaysFromNow)
            ]
        )
    );
  }

  static Query _getGamesReleasedTodayQuery() {
    String time1DayAgo = new DateTime.now()
        .subtract(new Duration(days: 1))
        .millisecondsSinceEpoch
        .toString();

    String time1DayFromNow = new DateTime.now()
        .add(new Duration(days: 1))
        .millisecondsSinceEpoch
        .toString();

    List<int> platforms = [
      Platforms.PLAYSTATION_VITA.id,
      Platforms.XBOX_ONE.id,
      Platforms.PLAYSTATION_4.id,
      Platforms.NINTENDO_3DS.id,
    ];

    String platformStr = platforms.join(',');

    return new Query(
        endpoint: Endpoints.GAMES,
        name: 'Games released today or yesterday',
        params: new RequestParameters(
            fields: GameServiceClient.fields,
            filters: [
              new Filter('release_dates.platform', FilterOperator.ANY, platformStr),
              new Filter('release_dates.region', FilterOperator.EQUAL, Regions.NORTH_AMERICA.id),
              new Filter('release_dates.date', FilterOperator.GREATER_THAN, time1DayAgo),
              new Filter('release_dates.date', FilterOperator.LESS_THAN, time1DayFromNow)
            ],
            limit: 10,
            order: 'first_release_date:asc'
        )
    );
  }
}