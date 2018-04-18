part of gametime;

class NoteCardViewModel {
  final Function(Note) removeNoteCallback;

  NoteCardViewModel({@required this.removeNoteCallback});

  static NoteCardViewModel fromStore(Store<AppState> store) {
    return new NoteCardViewModel(
        removeNoteCallback: (note) => store.dispatch(new RemoveNoteAction(note))
    );
  }
}

class NoteCard extends StatelessWidget {

  final Note note;
  final GameModel game;
  final bool showImageLeft;
  final bool showImageRight;

  NoteCard({
    @required this.note,
    @required this.game,
    this.showImageLeft = false,
    this.showImageRight = false
  });

  _onLongPress(BuildContext context, VoidCallback onPressedYes) {
    showDialog(
      context: context,
      child: new ConfirmationDialog(
          confirmationText: 'Are you sure you want to delete this note?',
          onPressedYes: onPressedYes,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, NoteCardViewModel>(
      converter: NoteCardViewModel.fromStore,
      builder: (context, viewModel) {
        return new InkWell(
          onLongPress: () => _onLongPress(context, () => viewModel.removeNoteCallback(note)),
          child: new TextCard(
            mainText: note.text,
            footerText: game.name,
            headerText: note.getDateAsNiceString(),
            leftWidget: showImageLeft ? new GameImage(game: game) : null,
            rightWidget: showImageRight ? new GameImage(game: game) : null,
          ),
        );
      },
    );
  }
}