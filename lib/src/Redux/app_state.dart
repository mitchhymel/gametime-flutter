part of gametime;

@immutable
class AppState {

  final Map<String, GameModel> games;
  final List<Note> notes;
  final List<Session> sessions;
  final Session currentActiveSession;
  final CustomTheme theme;
  final List<Query> queries;
  final FirebaseUser firebaseUser;
  final Regions region = Regions.NORTH_AMERICA;

  AppState({
    this.games,
    this.notes,
    this.sessions,
    this.currentActiveSession,
    this.theme,
    this.queries,
    this.firebaseUser
  });

  AppState copyWith({
    Map<String, GameModel> games,
    List<Note> notes,
    List<Session> sessions,
    Session currentActiveSession,
    CustomTheme theme,
    List<Query> queries,
    FirebaseUser firebaseUser
  }) {
    return new AppState(
      games: games ?? this.games,
      notes: notes ?? this.notes,
      sessions: sessions ?? this.sessions,
      currentActiveSession: currentActiveSession ?? this.currentActiveSession,
      theme: theme ?? this.theme,
      queries: queries ?? this.queries,
      firebaseUser: firebaseUser ?? this.firebaseUser
    );
  }

  static AppState initialState() {
    return new AppState(
        games: new Map<String, GameModel>(),
        notes: new List<Note>(),
        sessions: new List<Session>(),
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
      'notes': this.notes.toString(),
      'sessions': this.sessions.toString(),
      'currentActiveSession': this.currentActiveSession.toString(),
      'firebaseUser': this.firebaseUser.toString()
    });
  }
}


