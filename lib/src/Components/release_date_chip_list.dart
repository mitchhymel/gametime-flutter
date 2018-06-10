part of gametime;

class _ReleaseDateChipListViewModel {
  final Regions region;
  _ReleaseDateChipListViewModel({this.region});

  static _ReleaseDateChipListViewModel fromStore(Store<AppState> store) {
    return new _ReleaseDateChipListViewModel(
      region: store.state.region,
    );
  }
}


class ReleaseDateChipList extends StatelessWidget {

  final GameModel game;
  ReleaseDateChipList(this.game);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      converter: _ReleaseDateChipListViewModel.fromStore,
      builder: (context, viewModel) {
        if (game.releaseDates == null || game.releaseDates.length == 0) {
          return new Container();
        }

        List<ReleaseDate> releaseDatesForRegion = game.releaseDates
            .where((r) => (r.region.id == viewModel.region.id || r.region.id == Regions.WORLDWIDE.id)).toList();

        if (releaseDatesForRegion.length == 0) {
          return new Container();
        }

        return new HorizontalChipList<ReleaseDate>(
          list: releaseDatesForRegion,
          stringTransform: (r) => '${DateTimeHelper.getMonthDayYear(r.date)} on ${r.platform.name}',
        );
      },
    );
  }
}