part of gametime;

class AddRemoveFab extends StatelessWidget {

  final bool isAdd;
  final VoidCallback onClickIfAdd;
  final VoidCallback onClickIfRemove;

  AddRemoveFab(
    this.isAdd,
    this.onClickIfAdd,
    this.onClickIfRemove
  );

  @override
  Widget build(BuildContext context) {
    if (isAdd) {
      return new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: onClickIfAdd,
      );
    }

    return new FloatingActionButton(
      child: new Icon(Icons.remove),
      onPressed: onClickIfRemove,
    );
  }
}