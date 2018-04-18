part of gametime;


class EditQueryPage extends StatefulWidget {
  final Query query;

  EditQueryPage({this.query});

  @override
  _EditQueryPageState createState() {
    if (this.query == null) {
      return new _EditQueryPageState();
    }

    return null;
  }
}

class EditQueryPageViewModel {

  final Function(Query) onSave;

  EditQueryPageViewModel({this.onSave});

  static EditQueryPageViewModel fromStore(Store<AppState> store) {
    return new EditQueryPageViewModel(
      onSave: (q) => {}
    );
  }
}

class _EditQueryPageState extends State<EditQueryPage> {
  String name;
  List<Regions> regions;
  List<Platforms> platforms;
  List<Genres> genres;
  int numDaysBeforeNow;
  int numDaysAfterNow;

  _EditQueryPageState({
    this.name,
    this.regions,
    this.platforms,
    this.genres,
    this.numDaysBeforeNow,
    this.numDaysAfterNow
  });

  @override
  void initState() {
    super.initState();
    setState((){

    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Query'),
      ),
      body: new Container(),
    );
  }
}