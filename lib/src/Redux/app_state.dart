part of gametime;

@immutable
class AppState {

  final Map<String, GameModel> games;
  final Map<String, List<Note>> gameToNotes;
  final Map<String, List<Session>> gameToSessions;
  final Session currentActiveSession;
  final CustomTheme theme;
  final List<Query> queries;
  final FirebaseUser firebaseUser;
  final Regions region = Regions.NORTH_AMERICA;

  AppState({
    this.games,
    this.gameToNotes,
    this.gameToSessions,
    this.currentActiveSession,
    this.theme,
    this.queries,
    this.firebaseUser
  });

  AppState copyWith({
    Map<String, GameModel> games,
    Map<String, List<Note>> gameToNotes,
    Map<String, List<Session>> gameToSessions,
    Session currentActiveSession,
    CustomTheme theme,
    List<Query> queries,
    FirebaseUser firebaseUser
  }) {
    return new AppState(
      games: games ?? this.games,
      gameToNotes: gameToNotes ?? this.gameToNotes,
      gameToSessions: gameToSessions ?? this.gameToSessions,
      currentActiveSession: currentActiveSession ?? this.currentActiveSession,
      theme: theme ?? this.theme,
      queries: queries ?? this.queries,
      firebaseUser: firebaseUser ?? this.firebaseUser
    );
  }

  static AppState initialState() {
    return new AppState(
        games: new Map<String, GameModel>(),
        gameToNotes: new Map<String, List<Note>>(),
        gameToSessions: new Map<String, List<Session>>(),
        currentActiveSession: new Session(gameId: ''),
        theme: new BlackRedTheme(),
        queries: Query.getDefault(),
        firebaseUser: null
    );
  }

  @override
  String toString() {
    return JSON.encode({
      'games': this.games.toString(),
      'notes': this.gameToNotes.toString(),
      'sessions': this.gameToSessions.toString(),
      'currentActiveSession': this.currentActiveSession.toString(),
      'firebaseUser': this.firebaseUser.toString()
    });
  }
}


