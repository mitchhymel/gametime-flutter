part of gametime;

class SettingsPageViewModel {
  final Function(CustomTheme) onChangeTheme;
  final Function onLogout;

  SettingsPageViewModel({this.onChangeTheme, this.onLogout});

  static SettingsPageViewModel fromStore(Store<AppState> store) {
    return new SettingsPageViewModel(
      onChangeTheme: (theme) => store.dispatch(new ChangeThemeAction(theme: theme)),
      onLogout: () => store.dispatch(new LogoutAction())
    );
  }
}

class SettingsPage extends StatelessWidget {

  Widget _getThemeComponent(BuildContext context, Function(CustomTheme) onChangeTheme) {
    return new Column(
      children: <Widget>[
        new Text('Theme', style: Theme.of(context).textTheme.headline),
        new RadioButtonList(
          items: CustomTheme.getAllThemes().map((theme) {
            return new RadioButtonItem(title: theme.name, onClick: () => onChangeTheme(theme));
          }).toList()
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SettingsPageViewModel>(
      converter: SettingsPageViewModel.fromStore,
      builder: (context, viewModel) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Settings'),
          ),
          body: new Center(
              child: new Column(
                children: <Widget>[
                  _getThemeComponent(context, viewModel.onChangeTheme),
                  new RaisedButton(
                    onPressed: () {
                      // viewModel.onLogout();
                    },
                    child: new Text('Log out'),
                  )
                ],
              )
          ),
        );
      },
    );
  }
}
