part of gametime;

class BrowsePage extends StatelessWidget {

  Future<List<ReleaseDate>> _requestData(int page, int pageSize) async {
    GameServiceClient client = new GameServiceClient();

    String timeNow = new DateTime.now()
        .millisecondsSinceEpoch
        .toString();

    List resp = await client.releaseDates(
        new RequestParameters(
            filters: [
              new Filter('date', FilterOperator.GREATER_THAN, timeNow),
              new Filter('region', FilterOperator.EQUAL, Regions.NORTH_AMERICA.id),
            ],
            expand: 'game',
            limit: pageSize,
            order: 'date:asc',
            offset: 1+page*pageSize,
        )
    );

    List<ReleaseDate> result = new List<ReleaseDate>();
    resp.forEach((date) {
      result.add(ReleaseDate.fromMap(date, expandGame: true));
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new PaginatedInfiniteScrollView<ReleaseDate>(
      pageRequest: _requestData,
      widgetAdapter: (releaseDate) => new ReleaseDateCard(date: releaseDate),
    );
  }
}