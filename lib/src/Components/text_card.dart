part of gametime;

class TextCard extends StatelessWidget {

  final String mainText;
  final String footerText;
  final String headerText;
  final Widget leftWidget;
  final Widget rightWidget;

  TextCard({
    @required this.mainText,
    this.footerText,
    this.headerText,
    this.leftWidget,
    this.rightWidget
  });

  Widget _getLeftWidget() {
    if (leftWidget == null) {
      return new Container();
    }

    return leftWidget;
  }

  Widget _getRightWidget() {
    if (rightWidget == null) {
      return new Container();
    }

    return rightWidget;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getLeftWidget(),
          new Expanded(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  headerText == null ? new Container() : new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                          headerText,
                          style: Theme.of(context).textTheme.caption
                      )
                    ],
                  ),
                  new Container(
                    padding: new EdgeInsets.all(5.0),
                    child: new Center(
                      child: new Text(
                        mainText,
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  footerText == null ? new Container() : new Column(
                    children: <Widget>[
                      new Text(
                        footerText,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  )
                ],
              )
          ),
          _getRightWidget()
        ],
      ),
    );
  }
}