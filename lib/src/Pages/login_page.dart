part of gametime;

class LoginPageViewModel {
  final FirebaseUser firebaseUser;
  final VoidCallback onLoginClicked;

  LoginPageViewModel({
    this.firebaseUser,
    this.onLoginClicked
  });

  static LoginPageViewModel fromStore(Store<AppState> store) {
    return new LoginPageViewModel(
        firebaseUser: store.state.firebaseUser,
        onLoginClicked: () => store.dispatch(new LoginAction())
    );
  }
}

class LoginPage extends StatelessWidget {

  onLoginClicked(context) async {
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, LoginPageViewModel>(
      converter: LoginPageViewModel.fromStore,
      builder: (context, viewModel) {
        return new Scaffold(
            body: new Center(
                child: new MaterialButton(
                    onPressed: viewModel.onLoginClicked,
                    minWidth: 100.0,
                    color: Theme.of(context).accentColor,
                    child: new Text('login')
                )
            )
        );
      },
    );
  }
}
