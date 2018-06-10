part of gametime;

class SettingsPageViewModel {
  final Function(CustomTheme) onChangeTheme;
  final Function onLogout;
  final Function(Regions) onChangeRegion;
  final Regions region;

  SettingsPageViewModel({this.onChangeTheme, this.onLogout, this.onChangeRegion, this.region});

  static SettingsPageViewModel fromStore(Store<AppState> store) {
    return new SettingsPageViewModel(
      onChangeTheme: (theme) => store.dispatch(new ChangeThemeAction(theme: theme)),
      onLogout: () => store.dispatch(new LogoutAction()),
      onChangeRegion: (region) => store.dispatch(new ChangeRegionAction(region)),
      region: store.state.region,
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

  Widget _getRegionSelectorComponent(BuildContext context,  Regions region,
      Function(Regions) onChangeRegion) {
    return new Row(
      children: <Widget>[
        new Text('Choose your primary region', style: Theme.of(context).textTheme.body2,),
        new Container(width: 20.0,),
        new DropdownButton(
            value: region,
            items: Regions.all().map((r) => new DropdownMenuItem(child: new Text(r.name), value: r)).toList(),
            onChanged: (region) => onChangeRegion(region),
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
                  ),
                  _getRegionSelectorComponent(context, viewModel.region, viewModel.onChangeRegion),
                ],
              )
          ),
        );
      },
    );
  }
}
