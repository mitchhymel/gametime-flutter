part of gametime;

class GameStatsTab extends StatelessWidget {
  final GameModel game;
  final List<Session> sessions;

  GameStatsTab(this.game, this.sessions);


  Widget _getTotalPlayTime(List<Session> sessions) {
    Duration total = new Duration();
    sessions.forEach((s) => total += (s.dateEnded.difference(s.dateStarted)));

    return new TextCard(
      mainText: DateTimeHelper.getDurationInHoursMins(total),
      footerText: "Total Play Time",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sessions == null || sessions.isEmpty) {
      return new Container();
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getTotalPlayTime(sessions),
      ],
    );
  }
}