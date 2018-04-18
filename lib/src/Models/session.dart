part of gametime;

class Session implements Activity {
  String gameId;
  DateTime dateStarted;
  DateTime dateEnded;

  Session({
    this.gameId,
    this.dateStarted,
    this.dateEnded
  });

  @override
  bool operator==(Object other) {
    return other is Session
        && other.gameId == this.gameId
        && other.dateStarted == this.dateStarted
        && other.dateEnded == this.dateEnded;
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': this.gameId,
      'dateStarted': this.dateStarted.toString(),
      'dateEnded': this.dateEnded.toString()
    };
  }

  @override
  String toString() {
    return JSON.encode(this.toMap());
  }

  bool isValidActiveSession() {
    return this.gameId != null && this.gameId.isNotEmpty && this.dateEnded == null;
  }

  String getSessionString() {
    Duration difference = dateEnded.difference(dateStarted);
    return 'You played for ${difference.inMinutes} minute(s) on ${dateStarted.month}/${dateStarted.day}/${dateStarted.year}';
  }

  String getDateAsNiceString() {
    return '${dateStarted.month}/${dateStarted.day}/${dateStarted.year}';
  }

  String getPlayTimeString() {
    int secondsDiff = dateEnded.difference(dateStarted).inSeconds;
    int hours = secondsDiff~/3600;
    int minutesToDisplay = (secondsDiff~/60) - hours*60;

    return 'Played: $hours:${minutesToDisplay >= 10 ? minutesToDisplay : '0' + minutesToDisplay.toString()}';
  }

  @override
  DateTime getDateTime() {
    return dateStarted;
  }

  @override
  String getGameId() {
    return gameId;
  }

  static Session getInactiveSession() {
    return new Session(gameId: '');
  }

  static Session fromMap(Map map) {
    return new Session(
        dateEnded: map['dateEnded'] == null || map['dateEnded'] == 'null' ? null : DateTime.parse(map['dateEnded']),
        gameId: map['gameId'] is int ? map['gameId'].toString() : map['gameId'],
        dateStarted: map['dateStarted'] == null || map['dateStarted'] == 'null' ? null : DateTime.parse(map['dateStarted'])
    );
  }
}