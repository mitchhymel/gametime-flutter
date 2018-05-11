part of gametime;

@immutable
class _DetailsPageViewModel {
  final List<Note> notes;
  final List<Session> sessions;

  _DetailsPageViewModel({
    this.notes,
    this.sessions,
  });

  static _DetailsPageViewModel fromStore(Store<AppState> store, GameModel game) {
    return new _DetailsPageViewModel(
        notes: store.state.notes.where((note) => note.gameId == game.id).toList(),
        sessions: store.state.sessions.where((session) => session.gameId == game.id).toList(),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final GameModel game;
  final String source;
  DetailsPage({@required this.game, this.source=''});

  @override
  _DetailsPageState createState() => new _DetailsPageState(game: this.game, source: this.source);
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  final GameModel game;
  final String source;
  TabController _controller;
  ScrollController _scrollController;

  _DetailsPageState({@required this.game, @required this.source});

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this, initialIndex: 0);
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Widget _getCustomAppBar(BuildContext context, GameModel game) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double fadedImageWidth = screenWidth;
    double fadedImageHeight = screenHeight / 2;
    double clearImageWidth = screenWidth / 2.5;
    double clearImageHeight = screenHeight / 4;
    
    return new SliverAppBar(
      title: new Text(game.name, style: Theme.of(context).textTheme.title),
      backgroundColor: Theme.of(context).primaryColor,
      pinned: true,
      expandedHeight: fadedImageHeight - MediaQuery.of(context).padding.top,
      bottom: _getTabBar(context),
      flexibleSpace: new FlexibleSpaceBar(
        background: new Stack(
            children: <Widget>[
              new GameImage(
                game: game,
                heroTag: 'somethingelse',
                width: fadedImageWidth,
                height: fadedImageHeight,
                fit: BoxFit.cover,
              ),
              new ClipRect(
                child: new BackdropFilter(
                  filter: new dartui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: new Container(
                    width: fadedImageWidth,
                    height: fadedImageHeight,
                    decoration: new BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.05)
                    ),
                  ),
                ),
              ),
              new Hero(
                tag: game.id + 'card1', //TODO: change to get hero animation
                child: new Container(
                  height: fadedImageHeight,
                  width: fadedImageWidth,
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: <Color>[
                          Colors.transparent,
                          Theme.of(context).primaryColor
                        ],
                        stops: [0.0, 0.95],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                      )
                  ),
                ),
              ),
              new Center(
                  child: new GameImage(
                    game: game,
                    width: clearImageWidth,
                    height: clearImageHeight,
                    heroTag: game.id + source,
                    fit: BoxFit.scaleDown,
                  )
              ),
            ],
          ),
        ),
    );
  }

  Widget _getTabBar(BuildContext context) {
    return new TabBar(
      controller: _controller,
      tabs: <Tab>[
        new Tab(
          text: 'Info',
        ),
        new Tab(
          text: 'Stats',
        ),
        new Tab(
          text: 'Sessions',
        ),
        new Tab(
          text: 'Notes',
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    debugPrint(game.toString());

    return new StoreConnector<AppState, _DetailsPageViewModel>(
      converter: (store) => _DetailsPageViewModel.fromStore(store, game),
      builder: (context, viewModel) {
        var tabs = [ new GameInfoTab(game),
        new GameStatsTab(game, viewModel.sessions),
        new GameSessionsTab(game, viewModel.sessions),
        new GameNotesTab(game, viewModel.notes),];
        return new Scaffold(
          body: new DefaultTabController(
              length: tabs.length,
              child: new NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    new SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      child: _getCustomAppBar(context, game),
                    )
                  ];
                },
                body: new TabBarView(
                  controller: _controller,
                  children: tabs.map((t) {
                    return new SafeArea(
                      top: false,
                      bottom: false,
                      child: new Builder(
                        builder: (context) {
                          return new CustomScrollView(
                            slivers: <Widget>[
                              new SliverOverlapInjector(
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              ),
                              new SliverToBoxAdapter(
                                child: t,
                              ),
                            ]
                          );
                        }
                      )
                    );
                  }).toList(),
                )
              )
          ),
          floatingActionButton: new GameDetailFabDial(game: game),
        );
      }
    );
  }
}

