part of gametime;

class _AppViewModel {
  final ThemeData themeData;
  final FirebaseUser firebaseUser;
  _AppViewModel({@required this.themeData, @required this.firebaseUser});

  static _AppViewModel fromStore(Store<AppState> store) {
    return new _AppViewModel(
        themeData: store.state.theme.getThemeData(),
        firebaseUser: store.state.firebaseUser
    );
  }
}

class App extends StatelessWidget {
  final Store<AppState> store = new Store<AppState>(
      stateReducer,
      initialState: AppState.initialState(),
      middleware: [
        //loggerMiddleware,
        //sqlliteMiddleware,
        firebaseMiddleware
      ].toList()
  );

  @override
  Widget build(BuildContext context) {
    NotificationHelper.initialize();
    store.dispatch(new InitAction());
    return new AppLifeCycleWatcher(
      new StoreProvider<AppState>(
        store: store,
        child: new StoreConnector<AppState, _AppViewModel>(
          converter: _AppViewModel.fromStore,
          builder: (context, viewModel) {
            return new MaterialApp(
              title: 'GameTime',
              theme: viewModel.themeData,
              home: viewModel.firebaseUser == null ? new LoginPage() : new MainPage(),
            );
          },
        ),
      ),
    );
  }
}



prettyPrint(Map obj) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  debugPrint(encoder.convert(obj));
}