part of gametime;

class GameGrid extends StatelessWidget {
  final Map<String, GameModel> games;
  final bool shouldUseImageHero;
  final int crossAxisCount;

  GameGrid({
    @required this.games,
    this.shouldUseImageHero = false,
    this.crossAxisCount = 3
  });

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: crossAxisCount,
      children: (games == null || games.isEmpty) ?
      []
          :
      games.values.map((GameModel game) {
        return new GameImage(
          game: game,
          heroTag: shouldUseImageHero ? game.id : null,
            fit: BoxFit.cover
        );
      }).toList(),
    );
  }
}