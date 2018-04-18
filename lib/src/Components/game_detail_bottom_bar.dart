part of gametime;

class _GameDetailBottomBarViewModel {

  final Function(GameModel) addGameCallback;
  final Function(GameModel) removeGameCallback;
  final Function(String) startSessionCallback;
  final VoidCallback endSessionCallback;
  final bool isInCollection;
  final bool hasActiveSession;
  final bool activeSessionIsThisGame;
  final bool addNoteButtonDisabled;
  final bool addRemoveButtonDisabled;
  final bool startStopButtonDisabled;

  _GameDetailBottomBarViewModel({
    this.addGameCallback,
    this.removeGameCallback,
    this.isInCollection,
    this.hasActiveSession,
    this.activeSessionIsThisGame,
    this.startSessionCallback,
    this.endSessionCallback,
    this.addNoteButtonDisabled,
    this.addRemoveButtonDisabled,
    this.startStopButtonDisabled
  });

  static _GameDetailBottomBarViewModel fromStore(Store<AppState> store, GameModel game) {
    bool isInCollection = store.state.games.containsKey(game.id);

    bool hasActiveSession = store.state.currentActiveSession != null && store.state.currentActiveSession.isValidActiveSession();
    bool activeSessionIsThisGame = hasActiveSession && store.state.currentActiveSession.gameId == game.id;
    bool addNoteButtonDisabled = !isInCollection;
    bool addRemoveButtonDisabled = hasActiveSession && activeSessionIsThisGame;
    bool startStopButtonDisabled = !isInCollection || (hasActiveSession && !activeSessionIsThisGame);

    return new _GameDetailBottomBarViewModel(
      isInCollection: isInCollection,
      addGameCallback: ((game) => store.dispatch(new AddGameAction(game))),
      removeGameCallback: ((game) => store.dispatch(new RemoveGameAction(game))),
      startSessionCallback: ((gameId) => store.dispatch(new StartSessionAction(new Session(gameId: gameId, dateStarted: new DateTime.now())))),
      endSessionCallback: () => store.dispatch(new EndSessionAction(new DateTime.now())),
      hasActiveSession: hasActiveSession,
      activeSessionIsThisGame: activeSessionIsThisGame,
      addNoteButtonDisabled: addNoteButtonDisabled,
      addRemoveButtonDisabled: addRemoveButtonDisabled,
      startStopButtonDisabled: startStopButtonDisabled
    );
  }
}

class GameDetailBottomBar extends StatelessWidget {

  final int _notificationId = 0;

  final GameModel game;
  GameDetailBottomBar({@required this.game});

  onNotificationClick(String payload) {
    //TODO: route to game detail page
    print('in onNotificationClick with payload: $payload');
  }

  Widget _getButtonColumn(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return new FlatButton(
        disabledColor: Colors.blueGrey,
        onPressed: onPressed,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(icon, color: Colors.white,),
            new Container(
                margin: new EdgeInsets.all(8.0),
                child: new Text(
                    label,
                    style: Theme.of(context).textTheme.button
                )
            )
          ],
        )
    );
  }

  Widget _getAddRemoveButton(BuildContext context, bool isAdd, VoidCallback onClickIfAdd, VoidCallback onClickIfRemove) {
    return isAdd ?
    _getButtonColumn(context, Icons.add, "Add", onClickIfAdd)
        :
    _getButtonColumn(context, Icons.remove, "Remove", onClickIfRemove);
  }

  Widget _getStartStopSession(BuildContext context, bool isStart, VoidCallback onClickIfStart, VoidCallback onClickIfStop) {
    return isStart ?
    _getButtonColumn(context, Icons.alarm_add, "Start", onClickIfStart == null ? null : () async {
      await NotificationHelper.createNotification(game, DateTime.now(), onClickIfStop);
      onClickIfStart();
    })
        :
    _getButtonColumn(context, Icons.alarm_off, "Stop", onClickIfStop == null ? null : () async {
      await NotificationHelper.removeNotification();
      onClickIfStop();
    });
  }

  _onRemoveClick(BuildContext context, VoidCallback onConfirmationYes) {
    showDialog(
        context: context,
        child: new ConfirmationDialog(
          confirmationText: 'Are you sure you want to remove this from your collection? This will erase all sessions and notes.',
          onPressedYes: onConfirmationYes,
        )
    );
  }

  _onAddNoteClicked(BuildContext context, GameModel game) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddNotePage(
              game: game
          );
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _GameDetailBottomBarViewModel>(
      converter: (store) => _GameDetailBottomBarViewModel.fromStore(store, game),
        builder: (context, viewModel) {
          return new Material(
            color: Colors.transparent,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _getButtonColumn(
                    context,
                    Icons.edit,
                    'Note',
                    viewModel.addNoteButtonDisabled ? null :  () => _onAddNoteClicked(context, game)
                ),
                _getAddRemoveButton(
                    context,
                    !viewModel.isInCollection,
                    viewModel.addRemoveButtonDisabled ? null : () => viewModel.addGameCallback(game),
                    viewModel.addRemoveButtonDisabled ? null : () => _onRemoveClick(context, () => viewModel.removeGameCallback(game))
                ),
                _getStartStopSession(
                    context,
                    !viewModel.activeSessionIsThisGame,
                    viewModel.startStopButtonDisabled ? null : () => viewModel.startSessionCallback(game.id),
                    viewModel.startStopButtonDisabled ? null : () => viewModel.endSessionCallback()
                ),
//                new CustomToggleButton(
//                  isOn: true,
//                  whenOff: new CustomToggleButtonSettings(
//                    onClick: () => print('im off, to on'),
//                    icon: Icons.blur_off,
//                    label: 'blur off'
//                  ),
//                  whenOn: new CustomToggleButtonSettings(
//                    onClick: () => print('im on, to off'),
//                    icon: Icons.blur_on,
//                    label: 'blur on'
//                  )
//                )
              ],
            ),
          );
        }
    );
  }
}