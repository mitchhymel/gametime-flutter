part of gametime;

class GameNotesTab extends StatelessWidget {
  final GameModel game;
  final List<Note> notes;

  GameNotesTab(this.game, this.notes);

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return new Container();
    }

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        ]..addAll(notes.map((note) => new NoteCard(note: note, game: game)).toList())
    );
  }
}