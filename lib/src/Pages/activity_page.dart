part of gametime;

class ActivityPageViewModel {
  final Map<String, GameModel> games;
  final Session currentActiveSession;
  final List<Activity> activities;

  ActivityPageViewModel({this.games, this.currentActiveSession, this.activities});

  static ActivityPageViewModel fromStore(Store<AppState> store) {

    List<Activity> copiedActivities = []..addAll(store.state.notes)..addAll(store.state.sessions);
    copiedActivities.sort((a,b) => b.getDateTime().compareTo(a.getDateTime()));

    List<Session> copiedSessions = []..addAll(store.state.sessions);
    copiedSessions.sort((a,b) => b.getDateTime().compareTo(a.getDateTime()));

    return new ActivityPageViewModel(
        games: store.state.games,
        activities: copiedActivities,
        currentActiveSession: store.state.currentActiveSession,
    );
  }
}

class ActivityPage extends StatelessWidget {

  Widget _getItem(int index, List<Activity> activities,Map<String, GameModel> games) {
    Activity activity = activities[index];
    if (games[activity.getGameId()] == null) {
      // debugPrint('game not found in games map');
      return new Container();
    }

    if (activity is Session) {
      Session session = activity;
      return new SessionCard(
        session: session,
        game: games[session.gameId],
        showImageLeft: index%2 == 0,
        showImageRight: index%2 == 1,
      );
    }
    else if (activity is Note) {
      Note note = activity;
      return new NoteCard(
        note: note,
        game: games[note.gameId],
        showImageLeft: index%2 == 0,
        showImageRight: index%2 == 1,
      );
    }
    else {
      debugPrint('Activity was not a note or session');
    }

    return new Container();
  }

  Widget _getCurrentSession(BuildContext context, Session session, Map<String, GameModel> games) {
    if (!session.isValidActiveSession()) {
      return new Container();
    }

    GameModel game = games[session.gameId];
    DateTime startTime = session.dateStarted;
    String startTimeStr = '${startTime.hour%12}:${startTime.minute >= 10 ? startTime.minute : '0' + startTime.minute.toString()} ${startTime.hour/12 > 1 ? 'PM' : 'AM'}';

    return new Card(
      elevation: 4.0,
      child: new InkWell(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height/5,
              child: new GameImage(
                  game: game,
                  fit: BoxFit.cover,
                  toDetail: true,
              ),
            ),
            new Expanded(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(5.0),
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          new Text(
                              'Started playing',
                              style: Theme.of(context).textTheme.caption
                          ),
                          new Text(
                            '${game.name}',
                            style: Theme.of(context).textTheme.headline,
                          ),
                          new Text(
                            'at $startTimeStr',
                            style: Theme.of(context).textTheme.caption
                          )
                        ],
                      )
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }


  Widget _getActivityList(BuildContext context,
      List<Activity> activities, Map<String, GameModel> games) {

    List<Widget> children = new List<Widget>();
    for (int i = 0; i < activities.length; i++) {
      children.add(_getItem(i, activities, games));
    }

    return new Column(
      children: children
    );

//    return new Container(
//      height: MediaQuery.of(context).size.height * .4,
//      child: new ListView.builder(
//          itemCount: activities.length,
//          itemBuilder: (context, index) => _getItem(index, activities, games)
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ActivityPageViewModel>(
      converter: ActivityPageViewModel.fromStore,
      builder: (context, viewModel) {
        return new Scaffold(
          body: new ListView(
            children: <Widget>[
//              _getCurrentSession(
//                  context,
//                  viewModel.currentActiveSession,
//                  viewModel.games
//              ),
              //new ActivityHeatMap(activities: viewModel.activities),
              new RecentGameList(),
            ],
          )
        );
      },
    );
  }
}