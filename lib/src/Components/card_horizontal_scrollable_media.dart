part of gametime;

class HorizontalScrollableMediaCard extends StatelessWidget {
  final double height;
  final List<Widget> children;

  HorizontalScrollableMediaCard({@required this.height, @required this.children});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Stack(
        children: <Widget>[
          new Card(
            child: new Container(
              height: height,
              margin: new EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
          new Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            height: height,
            child:  new ListView(
              scrollDirection: Axis.horizontal,
              children: children,
            ),
          )
        ],
      ),
    );
  }
}