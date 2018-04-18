part of gametime;

class GameStatsTab extends StatelessWidget {
  final GameModel game;
  final List<Session> sessions;

  GameStatsTab(this.game, this.sessions);


  Widget _getTotalPlayTime(List<Session> sessions) {

    double minutes = 0.0;

    sessions.forEach((s) => minutes += (s.dateEnded.difference(s.dateStarted).inMinutes));
    double hours = minutes/60.0;

    int hoursToDisplay = hours.toInt();
    int mintuesToDisplay = (minutes%60).toInt();
    String text = "$hoursToDisplay:$mintuesToDisplay";

    return new TextCard(
      mainText: text,
      footerText: "Total Play Time",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
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