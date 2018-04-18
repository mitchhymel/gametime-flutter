part of gametime;

class HorizontalChipList extends StatelessWidget {

  final List<String> list;
  HorizontalChipList(this.list);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 5.0),
      height: 40.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[]
          ..addAll(list.map((text) => new Container(
            margin: new EdgeInsets.symmetric(horizontal: 2.0),
            child:  new Chip(label: new Text(text)),
          ))),
      ),
    );
  }
}