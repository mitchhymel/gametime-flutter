part of gametime;

class ActivityHeatMap extends StatelessWidget {
  final List<Activity> activities;

  ActivityHeatMap({@required this.activities});

  Widget _getActivityBlock(Duration duration) {
    Color highest = new Color(0xFF295F2C);
    Color high = new Color(0xFF409842);
    Color medium = new Color(0xFF87C775);
    Color low = new Color(0xFFCAE291);
    Color lowest = new Color(0xFFEEEEEE);

    Color colorToUse = lowest;
    int mins = duration.inMinutes;
    if (mins > 200) {
      colorToUse = highest;
    }
    else if (mins > 120) {
      colorToUse = high;
    }
    else if (mins > 60) {
      colorToUse = medium;
    }
    else if (mins > 0) {
      colorToUse = low;
    }


    return new Container(
      decoration: new BoxDecoration(
          color: colorToUse,
          border: new Border.all(
              width: 2.0
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return new Container();
    }

    //get activities in map of day to playtime
    List<Session> sessions = activities.where((a) => a is Session).toList();
    Map<DateTime, Duration> playTimeByDate = new Map<DateTime, Duration>();

    for (int i = 0; i < 14 * 7; i++) {
      DateTime nowMinusDays = new DateTime.now().subtract(new Duration(days: i));
      DateTime key = new DateTime(nowMinusDays.year, nowMinusDays.month, nowMinusDays.day);
      playTimeByDate.putIfAbsent(key, () => new Duration());
    }

    sessions.forEach((s) {
      DateTime key = new DateTime(s.dateStarted.year, s.dateStarted.month, s.dateStarted.day);
      if (!playTimeByDate.containsKey(key)) {
        playTimeByDate[key] = new Duration();
      }

      Duration playTimeForSession = s.dateEnded.difference(s.dateStarted);

      playTimeByDate[key] += playTimeForSession;
    });


    double gridHeight = MediaQuery.of(context).size.height * .3;

    return new Container(
        height: gridHeight,
        child: new Center(
          child: new GridView.count(
              crossAxisCount: 7,
              scrollDirection: Axis.horizontal,
              children: []
                ..addAll(playTimeByDate.entries.map((e) =>
                    _getActivityBlock(e.value)
                ).toList().reversed)
          ),
        )
    );
  }
}