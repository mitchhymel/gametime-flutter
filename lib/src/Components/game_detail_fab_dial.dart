part of gametime;

class _GameDetailFabDialViewModel {

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
  final GoogleSignInAccount googleUser;

  _GameDetailFabDialViewModel({
    this.addGameCallback,
    this.removeGameCallback,
    this.isInCollection,
    this.hasActiveSession,
    this.activeSessionIsThisGame,
    this.startSessionCallback,
    this.endSessionCallback,
    this.addNoteButtonDisabled,
    this.addRemoveButtonDisabled,
    this.startStopButtonDisabled,
    this.googleUser,
  });

  static _GameDetailFabDialViewModel fromStore(Store<AppState> store, GameModel game) {
    bool isInCollection = store.state.games.containsKey(game.id);

    bool hasActiveSession = store.state.currentActiveSession != null && store.state.currentActiveSession.isValidActiveSession();
    bool activeSessionIsThisGame = hasActiveSession && store.state.currentActiveSession.gameId == game.id;
    bool addNoteButtonDisabled = !isInCollection;
    bool addRemoveButtonDisabled = hasActiveSession && activeSessionIsThisGame;
    bool startStopButtonDisabled = !isInCollection || (hasActiveSession && !activeSessionIsThisGame);

    return new _GameDetailFabDialViewModel(
        isInCollection: isInCollection,
        addGameCallback: ((game) => store.dispatch(new AddGameAction(game))),
        removeGameCallback: ((game) => store.dispatch(new RemoveGameAction(game))),
        startSessionCallback: ((gameId) => store.dispatch(new StartSessionAction(new Session(gameId: gameId, dateStarted: new DateTime.now())))),
        endSessionCallback: () => store.dispatch(new EndSessionAction(new DateTime.now())),
        hasActiveSession: hasActiveSession,
        activeSessionIsThisGame: activeSessionIsThisGame,
        addNoteButtonDisabled: addNoteButtonDisabled,
        addRemoveButtonDisabled: addRemoveButtonDisabled,
        startStopButtonDisabled: startStopButtonDisabled,
        googleUser: store.state.googleUser,
    );
  }
}

class GameDetailFabDial extends StatelessWidget {

  final GameModel game;
  GameDetailFabDial({@required this.game});

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

  Widget _getFabItem(BuildContext context, IconData icon,
      String text, VoidCallback onClick) {
    bool isDisabled = onClick == null;

    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Chip(
          label: new Text(text, style: Theme.of(context).textTheme.title,),
          backgroundColor: isDisabled ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
        ),
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        new FloatingActionButton(
          backgroundColor: isDisabled ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
          mini: true,
          child: new Icon(icon, color: Colors.white),
          onPressed: onClick,
          heroTag: text,
        )
      ],
    );
//    return new SpeedDialerButton(
//      heroTag: text,
//      text: text,
//      foregroundColor: Theme.of(context).accentColor,
//      backgroundColor: Theme.of(context).primaryColor,
//      icon: icon,
//      onPressed: onClick,
//    );
//    return new FabMiniMenuItem(
//      text,
//      elevation: 6.0,
//      icon: new Icon(icon),
//      fabColor: Theme.of(context).accentColor,
//      text: text,
//      onPressed: onClick,
//      tooltip: text,
//      chipColor: Theme.of(context).accentColor,
//      textColor: Theme.of(context).textTheme.body1.color,
//    );
  }

  Widget _getNoteFab(BuildContext context,
      _GameDetailFabDialViewModel viewModel) {
    return _getFabItem(
      context,
      Icons.edit,
      'Add note',
      viewModel.addNoteButtonDisabled ? null :  () => _onAddNoteClicked(context, game)
    );
  }

  Widget _getAddRemoveFab(BuildContext context,
      _GameDetailFabDialViewModel viewModel) {

    bool isAdd = !viewModel.isInCollection;
    VoidCallback callback;
    if (!viewModel.addRemoveButtonDisabled) {
      if (isAdd) {
        callback = () => viewModel.addGameCallback(game);
      }
      else {
        callback = () => _onRemoveClick(context, () => viewModel.removeGameCallback(game));
      }
    }

    return _getFabItem(
      context,
      isAdd ? Icons.add : Icons.remove,
      isAdd ? 'Add' : 'Remove',
      callback,
    );
  }

  Widget _getStartStopFab(BuildContext context,
      _GameDetailFabDialViewModel viewModel) {

    bool isStart = !viewModel.activeSessionIsThisGame;
    VoidCallback callback;
    if (!viewModel.startStopButtonDisabled) {
      if (isStart) {
        callback = () async {
          await NotificationHelper.createNotification(game, DateTime.now(), viewModel.endSessionCallback);
          viewModel.startSessionCallback(game.id);
        };
      }
      else {
        callback = () async {
          await NotificationHelper.removeNotification();
          viewModel.endSessionCallback();
        };
      }
    }

    return _getFabItem(
      context,
      isStart ? Icons.timer : Icons.timer_off,
      isStart ? 'Start Session' : 'Stop Session',
      callback,
    );
  }

  Widget _getAddToCalendarFab(BuildContext context,
      _GameDetailFabDialViewModel viewModel) {
    return _getFabItem(
      context,
      Icons.calendar_today,
      'Save Release',
      () {
        List<Widget> children = [];
        children.addAll(game.releaseDates.map((r) => new SimpleDialogOption(
          child: new Text('${DateTimeHelper.getMonthDayYear(r.date)} on ${r.platform.name} in ${r.region.name}',
            style: Theme.of(context).textTheme.body2,
          ),
          onPressed: () async {
            final client = new GoogleCalendarClient();
            await client.init(viewModel.googleUser);
            await client.createEvent(game, r);
          },
        )));

        showDialog(
          context: context,
          builder: (context) {
            return new SimpleDialog(
              title: new Text('Save to calendar for which release date?'),
              children: children,
            );
          }
        );
      }
    );
  }

  List<Widget> _getFabItems(BuildContext context,
      _GameDetailFabDialViewModel viewModel) {

    List<Widget> list = [
      _getAddRemoveFab(context, viewModel),
      _getNoteFab(context, viewModel),
      _getStartStopFab(context, viewModel),
      _getAddToCalendarFab(context, viewModel)
    ];

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _GameDetailFabDialViewModel>(
        converter: (store) => _GameDetailFabDialViewModel.fromStore(store, game),
        builder: (context, viewModel) {
          return new SpeedDialer(
            heroTag: 'speeddial',
            children: _getFabItems(context, viewModel),
            iconData: Icons.add,
          );
//          return new FabDialer(
//              _getFabItems(context, viewModel),
//              Theme.of(context).accentColor,
//              new Icon(Icons.add)
//          );
        }
    );
  }
}