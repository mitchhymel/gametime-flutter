part of gametime;

class GrowOnClickWidget extends StatefulWidget {
  double begin;
  double end;
  Function onClick;
  Function<Widget>(double) resizeWidgetBuilder;
  GrowOnClickWidget({@required this.begin, @required this.end, @required this.resizeWidgetBuilder, @required this.onClick});
  @override
  _GrowOnClickWidgetState createState() => new _GrowOnClickWidgetState(this.begin, this.end, this.resizeWidgetBuilder, this.onClick);
}

class _GrowOnClickWidgetState extends State<GrowOnClickWidget> with SingleTickerProviderStateMixin {
  double begin;
  double end;
  Function onClick;
  Function<Widget>(double) resizeWidgetBuilder;

  _GrowOnClickWidgetState(this.begin, this.end, this.resizeWidgetBuilder, this.onClick);
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this
    );
    animation = new Tween(
        begin: begin,
        end: end
    ).animate(controller)
      ..addListener((){
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new GestureDetector(
          child: new Container(
            //padding: new EdgeInsets.symmetric(vertical: animation.value/2),
            child: resizeWidgetBuilder(animation.value),
          ),
          onTap: () {
            onClick();
          },
          onTapCancel: () {
            controller.reverse();
          },
          onTapDown: (details) {
            controller.forward();
          },
          onTapUp: (details) {
            controller.reverse();
          },
        )
      ],
    );
  }
}
