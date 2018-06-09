part of gametime;

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onSearchPressed(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new SearchPage();
        }
    ));
  }

  _onSettingsPressed(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new SettingsPage();
      }
    ));
  }

  Widget _getBottomNavigationBar(BuildContext context) {
    Color iconColor = Colors.white;// Theme.of(context).iconTheme.color;
    return new Material(
      color: Theme.of(context).primaryColor,
      child: new TabBar(
          indicatorColor: Theme.of(context).indicatorColor,
          controller: _controller,
          tabs: <Tab> [
            new Tab(
              icon: new Icon(Icons.search, color: iconColor),
              text: 'Browse',
            ),
            new Tab(
              icon: new Icon(Icons.home, color: iconColor),
              text: 'Activity'
            ),
            new Tab(
              icon: new Icon(Icons.games, color: iconColor),
              text: 'Collection'
            ),
          ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('GameTime'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () => _onSearchPressed(context)
          ),
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () => _onSettingsPressed(context)
          ),
        ],
        //bottom: _getTopNavigationBar(context)
      ),
      body: new TabBarView(
        controller: _controller,
        children: <Widget>[
          new BrowsePage(),
          new ActivityPage(),
          new CollectionPage(),
        ],
      ),
      bottomNavigationBar: _getBottomNavigationBar(context)
    );
  }
}