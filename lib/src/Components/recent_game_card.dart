part of gametime;

class _RecentGameModel {
  final GameModel game;
  final bool hasActiveSession;
  final bool activeSessionIsThisGame;
  final VoidCallback onButtonClick;
  final VoidCallback notificationCallback;
  final DateTime lastPlayed;
  final Duration totalPlaytime;

  _RecentGameModel({
    this.game,
    this.hasActiveSession,
    this.activeSessionIsThisGame,
    this.onButtonClick,
    this.notificationCallback,
    this.lastPlayed,
    this.totalPlaytime,
  });
}

class RecentGameCard extends StatelessWidget {

  final _RecentGameModel recentGame;
  RecentGameCard(this.recentGame);

  Widget _getThumbnail() {
    return new Container(
      alignment: new FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 0.0),
      child: new Hero(
        tag: recentGame.game.id + 'activitypage',
        child: new Container(
          width: 80.0,
          height: 80.0,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(recentGame.game.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(
                new Radius.circular(50.0),
              ),
              border: new Border.all(
                color: Colors.white,
                width: 1.0,
              )
          ),
        ),
      ),
    );
  }

  Widget _getCard(BuildContext context) {
    return new Hero(
      tag: recentGame.game.id + 'card',
      child: new Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                new BoxShadow(color: Colors.black,
                    blurRadius: 10.0,
                    offset: new Offset(0.0, 10.0)
                )
              ]
          ),
          child: new Container(
              margin: const EdgeInsets.only(left: 72.0, top: 16.0),
              constraints: new BoxConstraints.expand(),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(recentGame.game.name, style: Theme.of(context).textTheme.title,),
                  new Container(height:40.0),
                  new Row(
                    children: <Widget>[
                      new Icon(Icons.timer, size: 20.0, color: Colors.white),
                      new Container(width: 4.0),
                      new Text(DateTimeHelper.getDurationInHoursMins(recentGame.totalPlaytime)),
                      new Container(width: 32.0),
                      new Text('Last Played: ' + DateTimeHelper.getMonthDay(recentGame.lastPlayed)),
                    ],
                  )
                ],
              )
          )
      )
    );
  }

  Widget _getButton(BuildContext context) {
    if (recentGame.hasActiveSession && !recentGame.activeSessionIsThisGame) {
      return new Container();
    }

    VoidCallback onPressed = !recentGame.activeSessionIsThisGame ?
    () async {
      await NotificationHelper.createNotification(recentGame.game, DateTime.now(), recentGame.notificationCallback);
      recentGame.onButtonClick();
    } :
    () async {
      await NotificationHelper.removeNotification();
      recentGame.onButtonClick();
    };


    return new Container(
        alignment: new FractionalOffset(1.0, 1.0),
        margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: new FlatButton(
            shape: new CircleBorder(
                side: BorderSide.none
            ),
            color: Theme.of(context).dialogBackgroundColor,
            onPressed: onPressed,
            child: new Icon(
              recentGame.activeSessionIsThisGame ? Icons.alarm_off : Icons.alarm_add,
              color: Colors.white,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    if (recentGame.game == null) {
      return new Container();
    }

    double height = MediaQuery.of(context).size.height/4;
    double width = MediaQuery.of(context).size.width;
    return new Container(
        height: height,
        width: width,
        padding: new EdgeInsets.all(8.0),
        child: new GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return new DetailsPage(
                    game: recentGame.game,
                    source: 'activitypage',
                  );
                }
            ));
          },
          child: new Stack(
            children: <Widget>[
              _getCard(context),
              _getThumbnail(),
              _getButton(context),
            ],
          ),
        )
    );
  }
}