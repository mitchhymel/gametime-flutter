part of gametime;

typedef String StringTransformer<T>(T t);

class HorizontalChipList<T> extends StatelessWidget {

  final List<T> list;
  final StringTransformer<T> stringTransform;
  HorizontalChipList({this.list, this.stringTransform});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: 5.0),
      height: 40.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[]
          ..addAll(list.map((item) =>
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 2.0),
            child:  new Chip(
              label: new Text(
                stringTransform(item),
                style: Theme.of(context).textTheme.body2,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
          )),
      ),
    );
  }
}