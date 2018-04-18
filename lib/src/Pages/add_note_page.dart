part of gametime;

class AddNotePage extends StatefulWidget {
  final GameModel game;

  AddNotePage({this.game});

  @override
  AddNotePageState createState() => new AddNotePageState(game: this.game);
}

class AddNotePageViewModel {
  final Function(GameModel, Note) onSubmit;

  AddNotePageViewModel({this.onSubmit});

  static AddNotePageViewModel fromStore(Store<AppState> store) {
    return new AddNotePageViewModel(
      onSubmit: (game, note)  => store.dispatch(new AddNoteAction(game, note))
    );
  }
}

class AddNotePageState extends State<AddNotePage> {
  final TextEditingController _controller = new TextEditingController();
  AddNotePageState({this.game});

  final GameModel game;
  String _note;

  @override
  void initState() {
    super.initState();
    setState((){
      this._note = '';
    });
  }

  void _handleSubmit(BuildContext context, String text, Function(GameModel, Note) callback) {
    Note note = new Note(
      gameId: game.id,
      text: text,
      dateCreated: new DateTime.now()
    );

    callback(this.game, note);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AddNotePageViewModel>(
      converter: AddNotePageViewModel.fromStore,
      builder: (context, viewModel) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(game.name),
          ),
          body: new Container(
            child:  new Stack(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new TextField(
                      controller: _controller,
                      decoration: new InputDecoration(
                        hintText: 'Add your thoughts...',
                      ),
                      autofocus: true,
                      onChanged: (text) {
                        setState((){this._note = text;});
                      },
                      onSubmitted: (text) => _handleSubmit(context, text, viewModel.onSubmit),
                      autocorrect: true,
                      maxLines: 5,
                    )
                ),
                new Container(
                  alignment: new FractionalOffset(1.0, 1.0),
                  padding: new EdgeInsets.all(10.0),
                  child:  new FloatingActionButton(
                      child: new Icon(Icons.save),
                      onPressed: () => _handleSubmit(context, this._note, viewModel.onSubmit)
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}