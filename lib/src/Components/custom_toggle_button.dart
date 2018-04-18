part of gametime;

class CustomToggleButtonSettings {
  final String label;
  final VoidCallback onClick;
  final IconData icon;

  CustomToggleButtonSettings({
    this.label,
    this.onClick,
    this.icon
  });
}

class CustomToggleButton extends StatefulWidget {

  final CustomToggleButtonSettings whenOn;
  final CustomToggleButtonSettings whenOff;
  final bool isOn;

  CustomToggleButton({
    @required this.whenOn,
    @required this.whenOff,
    this.isOn=false
  });

  @override
  _CustomToggleButtonState createState() => new _CustomToggleButtonState(
      whenOn: this.whenOn,
      whenOff: this.whenOff,
      isOn: this.isOn
  );
}

class _CustomToggleButtonState extends State<CustomToggleButton> {

  final CustomToggleButtonSettings whenOn;
  final CustomToggleButtonSettings whenOff;

  bool isEnabled = true;
  bool isOn = false;

  _CustomToggleButtonState({
    @required this.whenOn,
    @required this.whenOff,
    this.isOn
  }) {
    if (this.isOn) {
      isEnabled = whenOn.onClick != null;
    }
    else {
      isEnabled = whenOff.onClick != null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  _handleClick() {
    print('in handle click: ${this.isEnabled}');
    if (!this.isEnabled) {
      return;
    }
    print('here');

    if (this.isOn) {
      this.whenOn.onClick();
    }
    else {
      this.whenOff.onClick();
    }

    setState((){
      print ('val is ${this.isOn}');
      this.isOn = !this.isOn;
    });
  }


  Widget _builder(double val) {
    CustomToggleButtonSettings settings = this.isOn ? this.whenOn : this.whenOff;

    return new Container(
      child: new Icon(
        settings.icon,
        color: Colors.white,
        size: val
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GrowOnClickWidget(
        begin: 60.0,
        end: 100.0,
        resizeWidgetBuilder: <Widget>(val) => _builder(val),
        onClick: _handleClick
    );
  }
}