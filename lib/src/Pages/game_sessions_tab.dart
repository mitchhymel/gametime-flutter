part of gametime;

class GameSessionsTab extends StatelessWidget {
  final GameModel game;
  final List<Session> sessions;

  GameSessionsTab(this.game, this.sessions);

  @override
  Widget build(BuildContext context) {
    if (sessions == null || sessions.isEmpty) {
      return new Container();
    }

    return new Column(
      children: []..addAll(sessions.map((session) => new SessionCard(session: session, game: game)).toList()),
    );

//    return new Column(
//      children: [
//        new Container(
//            padding: new EdgeInsets.all(5.0),
//            child: new Text(
//              "Sessions",
//              style: Theme.of(context).textTheme.display3,
//            )
//        )
//      ]..addAll(sessions.map((session) => new SessionCard(session: session, game: game)).toList()),
//    );
  }
}