part of gametime;

class SessionsCardViewModel {
  final Function(Session) removeSessionCallback;

  SessionsCardViewModel({@required this.removeSessionCallback});

  static SessionsCardViewModel fromStore(Store<AppState> store){
    return new SessionsCardViewModel(
        removeSessionCallback: (session) => store.dispatch(new RemoveSessionAction(session))
    );
  }
}

class SessionCard extends StatelessWidget {

  final Session session;
  final GameModel game;
  final bool showImageLeft;
  final bool showImageRight;

  SessionCard({
    @required this.session,
    @required this.game,
    this.showImageLeft = false,
    this.showImageRight = false
  });

  _onLongPress(BuildContext context, VoidCallback onPressedYes) {
    showDialog(
        context: context,
        child: new ConfirmationDialog(
          confirmationText: 'Are you sure you want to delete this session?',
          onPressedYes: onPressedYes,
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SessionsCardViewModel>(
      converter: SessionsCardViewModel.fromStore,
      builder: (context, viewModel) {
        return new InkWell(
          onLongPress: () => _onLongPress(context, () => viewModel.removeSessionCallback(session)),
          child: new TextCard(
            mainText: session.getPlayTimeString(),
            footerText: game.name,
            headerText: session.getDateAsNiceString(),
            leftWidget: showImageLeft ? new GameImage(game: game) : null,
            rightWidget: showImageRight ? new GameImage(game: game) : null,
          ),
        );
      },
    );
  }
}