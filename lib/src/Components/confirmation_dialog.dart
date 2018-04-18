part of gametime;

class ConfirmationDialog extends StatelessWidget {

  final String confirmationText;
  final VoidCallback onPressedYes;
  final VoidCallback onPressedNo;

  ConfirmationDialog({
    @required this.confirmationText,
    @required this.onPressedYes,
    this.onPressedNo
  });

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: new Text(confirmationText),
      actions: <Widget>[
        new FlatButton(
          child: new Text('No'),
          onPressed: (){
            Navigator.pop(context, false);
            if (onPressedNo != null) {
              onPressedYes();
            }
          }
        ),
        new FlatButton(
          child: new Text('Yes'),
          onPressed: (){
            Navigator.pop(context, true);
            onPressedYes();
          },
        ),
      ],
    );
  }
}