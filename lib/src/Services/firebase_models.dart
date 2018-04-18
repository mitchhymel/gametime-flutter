part of gametime;

class FirebaseGame {
  final String id;
  final int rating;
  final String name;
  FirebaseGame({
    this.id,
    this.rating,
    this.name
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'name': name
    };
  }

  static FirebaseGame fromMap(Map map) {
    return new FirebaseGame(
        id: map['id'],
        rating: map['rating'],
        name: map['name']
    );
  }

  static FirebaseGame fromSnapshot(DocumentSnapshot snapshot) {
    return fromMap(snapshot.data);
  }

  static FirebaseGame fromGameModel(GameModel game) {
    return new FirebaseGame(
        id: game.id,
        name: game.name
    );
  }
}

class FirebaseModelUtils {
  static Note noteFromSnapshot(DocumentSnapshot snapshot) {
    return new Note(
        text: snapshot.data['text'],
        gameId: snapshot.data['gameId'],
        dateCreated: DateTime.parse(snapshot.data['dateCreated'])
    );
  }

  static Session sessionFromSnapshot(DocumentSnapshot snapshot) {
    return new Session(
        dateEnded: DateTime.parse(snapshot.data['dateEnded']),
        gameId: snapshot.data['gameId'],
        dateStarted: DateTime.parse(snapshot.data['dateStarted'])
    );
  }
}

