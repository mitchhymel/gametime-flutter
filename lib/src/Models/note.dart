part of gametime;

class Note implements Activity {
  String gameId;
  String text;
  DateTime dateCreated;

  Note({
    this.gameId,
    this.text,
    this.dateCreated
  });

  @override
  bool operator==(Object other) {
    if (other is Note) {
      return this.gameId == other.gameId
          && this.text == other.text
          && this.dateCreated == other.dateCreated;
    }

    return false;
  }

  @override
  String toString() {
    return JSON.encode(this.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': this.gameId,
      'text': this.text,
      'dateCreated': this.dateCreated.toString()
    };
  }

  String getDateAsNiceString() {
    return '${dateCreated.month}/${dateCreated.day}/${dateCreated.year}';
  }

  @override
  DateTime getDateTime() {
    return dateCreated;
  }

  @override
  String getGameId() {
    return gameId;
  }

  static Note fromMap(Map map) {
    return new Note(
      text: map['text'],
      gameId: map['gameId'] is int ? map['gameId'].toString() : map['gameId'],
      dateCreated: DateTime.parse(map['dateCreated'])
    );
  }
}