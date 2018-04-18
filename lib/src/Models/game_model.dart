part of gametime;

class GameModel {
  final String id;
  final String name;
  final String url;
  final String summary;
  final String imageUrl;
  final List<Platforms> platforms;
  final List<Genres> genres;
  final List<ReleaseDate> releaseDates;
  final int rating;
  final double popularity;
  final double fanRating;
  final double criticRating;
  final List<Video> videos;
  final Duration totalTimePlayed;

  GameModel({
    this.id,
    this.name,
    this.url,
    this.summary,
    this.imageUrl,
    this.platforms = const [],
    this.genres = const [],
    this.releaseDates = const [],
    this.rating,
    this.popularity,
    this.fanRating,
    this.criticRating,
    this.videos,
    this.totalTimePlayed,
  });

  @override
  bool operator==(Object other) {
    if (other is GameModel){
      return this.id == other.id
        && this.name == other.name
        && this.url == other.url
        && this.summary == other.summary
        && this.imageUrl == other.imageUrl;
    }

    return false;
  }

  @override
  String toString() {
    return json.encode(this.toMap());
  }

  GameModel copyWith({
    String id,
    String name,
    String url,
    String summary,
    String imageUrl,
    List<Platforms> platforms,
    List<Genres> genres,
    List<ReleaseDate> releaseDates,
    int rating,
    double popularity,
    double fanRating,
    double criticRating,
    List<Video> videos,
    Duration totalTimePlayed,
  }){
    return new GameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      platforms: platforms ?? this.platforms,
      genres: genres ?? this.genres,
      releaseDates: releaseDates ?? this.releaseDates,
      rating: rating ?? this.rating,
      popularity: popularity ?? this.popularity,
      fanRating: fanRating ?? this.fanRating,
      criticRating: criticRating ?? this.criticRating,
      videos: videos ?? this.videos,
      totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
    );
  }

  static GameModel fromString(String str) {
    Map map = json.decode(str);
    return fromMap(map);
  }

  static GameModel fromMap(Map map) {
    return new GameModel(
        id: map['id'] is int ? map['id'].toString() : map['id'],
        url: map['url'],
        summary: map['summary'],
        imageUrl: map['imageUrl'],
        name: map['name']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'url': this.url,
      'summary': this.summary,
      'imageUrl': this.imageUrl,
      'name': this.name
    };
  }

  static GameModel fromIGDBGame(Game game) {
    return new GameModel(
      id: game.id.toString(),
      name: game.name,
      url: game.url,
      summary: game.summary,
      releaseDates: game.releaseDates,
      platforms: game.platforms,
      genres: game.genres,
      imageUrl: game.cover == null ? null : game.cover.getImageUrl(ImageSizes.HD720P, isRetina: true),
      popularity: game.popularity,
      fanRating: game.rating,
      criticRating: game.aggregatedRating,
      videos: game.videos,
    );
  }

}