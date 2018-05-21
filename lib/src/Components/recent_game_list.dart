part of gametime;

class _RecentGameListViewModel {

  final List<_RecentGameModel> recentGames;

  _RecentGameListViewModel({this.recentGames= const []});

  static _RecentGameListViewModel fromStore(Store<AppState> store) {

    // get the first session from each game
    List<Session> copiedSessions = store.state.gameToSessions
        .values.map((l) => l.first).toList();

    copiedSessions.sort((a,b) => b.getDateTime().compareTo(a.getDateTime()));
    //List<Session> lastTwenty = copiedSessions.take(20).toList();

    List<_RecentGameModel> recents = new List<_RecentGameModel>();
    while (copiedSessions.length > 0) {
      Session first = copiedSessions.first;

      List<Session> sessions = store.state.gameToSessions[first.gameId];
      Duration total = new Duration();
      sessions.forEach((s) => total += (s.dateEnded.difference(s.dateStarted)));

      bool hasActiveSession = store.state.currentActiveSession != Session.getInactiveSession();
      bool activeSessionIsThisGame = store.state.currentActiveSession.gameId == first.gameId;
      Function onButtonClick = (){};
      if (!hasActiveSession) {
        onButtonClick = () => store.dispatch(new StartSessionAction(
          new Session(
            gameId: first.gameId,
            dateStarted: DateTime.now(),
          )
        ));
      }
      else if (activeSessionIsThisGame) {
        onButtonClick = () => store.dispatch(new EndSessionAction(DateTime.now()));
      }

      recents.add(new _RecentGameModel(
        game: store.state.games[first.gameId],
        lastPlayed: sessions.first.dateStarted,
        totalPlaytime: total,
        activeSessionIsThisGame: activeSessionIsThisGame,
        hasActiveSession: hasActiveSession,
        onButtonClick: onButtonClick,
        notificationCallback: () => store.dispatch(new EndSessionAction(DateTime.now())),
      ));

      copiedSessions.removeAt(0);
    }

    return new _RecentGameListViewModel(
        recentGames: recents,
    );
  }
}

class RecentGameList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _RecentGameListViewModel>(
      converter: _RecentGameListViewModel.fromStore,
      builder: (context, _RecentGameListViewModel viewModel) {
        return new Column(
          children: viewModel.recentGames
              .map((r) => new RecentGameCard(r)).toList()
        );
      },
    );
  }
}