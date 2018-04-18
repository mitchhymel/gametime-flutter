part of gametime;

@immutable
class CollectionPageViewModel {
  final Map<String, GameModel> games;
  CollectionPageViewModel({this.games});

  static CollectionPageViewModel fromStore(Store<AppState> store) {
    return new CollectionPageViewModel(games: store.state.games);
  }
}

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, CollectionPageViewModel>(
      converter: CollectionPageViewModel.fromStore,
      builder: (context, viewModel) {
        return new Scaffold(
          body: new Column(
            children: <Widget>[
              new Expanded(
                child: new GameGrid(
                  games: viewModel.games,
                  crossAxisCount: 3,
                  shouldUseImageHero: true,
                )
              )
            ],
          )
        );
      }
    );
  }
}