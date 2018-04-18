part of gametime;

class RadioButtonItem {
  final String title;
  final VoidCallback onClick;

  RadioButtonItem({@required this.title, @required this.onClick});
}

class RadioButtonList extends StatefulWidget {
  final List<RadioButtonItem> items;

  RadioButtonList({@required this.items});

  @override
  _RadioButtonListState createState() => new _RadioButtonListState(items: items);
}

class _RadioButtonListState extends State<RadioButtonList> {

  int _groupValue = 0;
  final List<RadioButtonItem> items;
  _RadioButtonListState({@required this.items});

  _onChanged(int newValue, VoidCallback callback) {
    callback();

    setState(() {
      _groupValue = newValue;
    });
  }

  List<Widget> _getRadioButtons() {
    List<Widget> result = new List<Widget>();
    for (int i = 0; i < items.length; i++) {
      RadioButtonItem item = items[i];
      result.add(
        new RadioListTile(
          value: i,
          groupValue: _groupValue,
          onChanged: (newValue) => _onChanged(newValue, item.onClick),
          title: new Text(item.title),
        )
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: _getRadioButtons()
    );
  }
}