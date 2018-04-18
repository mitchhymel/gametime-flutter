part of gametime;

const String FirebaseUsersKey = 'users';
const String FirebaseCollectionKey = 'collection';
const String FirebaseNotesKey = 'notes';
const String FirebaseSessionsKey = 'sessions';

firebaseMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is InitAction) {
    await _initActionReducer(store, action);
  }
  else if (action is LoginAction) {
    await _loginActionReducer(store, action);
  }
  else if (action is LoginCompleteAction) {
    _loginCompleteActionReducer(store, action);
  }
  else if (action is LogoutAction) {
    _logoutActionReducer(store, action);
  }
  else if (action is AddGameAction) {
    _addGameActionReducer(store, action);
  }
  else if (action is RemoveGameAction) {
    _removeGameActionReducer(store, action);
  }
  else if (action is AddNoteAction) {
    _addNoteActionReducer(store, action);
  }
  else if (action is RemoveNoteAction) {
    _removeNoteActionReducer(store, action);
  }
  else if (action is StartSessionAction) {
    _startSessionActionReducer(store, action);
  }
  else if (action is EndSessionAction) {
    _endSessionActionReducer(store, action);
  }
  else if (action is RemoveSessionAction) {
    _removeSessionActionReducer(store, action);
  }

  next(action);
}

_initActionReducer(Store<AppState> store, action) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  if (store.state.firebaseUser == null) {
    auth.currentUser().then((user) async {
      if (user != null) {
        store.dispatch(new LoginCompleteAction(user));
      }
      else {
        final GoogleSignIn _googleSignIn = new GoogleSignIn();
        final GoogleSignInAccount gUser = await _googleSignIn.signInSilently();
        if (gUser != null) {
          final GoogleSignInAuthentication gAuth = await gUser.authentication;
          final FirebaseUser fbUser = await auth.signInWithGoogle(
              idToken: gAuth.idToken,
              accessToken: gAuth.accessToken
          );

          if (fbUser != null) {
            store.dispatch(new LoginCompleteAction(fbUser));
          }
        }
        else {
          debugPrint('guser was null after silent sign in');
        }
      }
    });
  }
}

_loginActionReducer(Store<AppState> store, action) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final GoogleSignInAccount gUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication gAuth = await gUser.authentication;
  final FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken
  );

  debugPrint('logged in as user ${user.uid}');

  store.dispatch(new LoginCompleteAction(user));
}

_loginCompleteActionReducer(Store<AppState> store, action) {
  DocumentReference reference = Firestore.instance
      .collection(FirebaseUsersKey)
      .document(action.firebaseUser.uid);

  _listenToActiveSession(store, reference);
  _listenToCollection(store, reference);
  _listenToNotes(store, reference);
  _listenToSessions(store, reference);
}

_listenToActiveSession(Store<AppState> store, DocumentReference reference) {
  reference.snapshots.listen((DocumentSnapshot event){
    if (event != null) {
      Map persistedValue = event.data['currentActiveSession'];
      if (persistedValue != null) {
        Session activeSession = Session.fromMap(persistedValue);
        if (activeSession.isValidActiveSession()) {
          store.dispatch(new AddActiveSessionAction(activeSession));
        }
      }
    }
  });
}

_listenToCollection(Store<AppState> store, DocumentReference reference) {
  // Add listener to retrieve the user's collection
  reference.getCollection(FirebaseCollectionKey).snapshots.listen((QuerySnapshot event) {
    if (event != null) {
      List<int> idsToFetch = new List<int>();
      for (DocumentSnapshot snapshot in event.documents) {
        FirebaseGame game = FirebaseGame.fromSnapshot(snapshot);
        if (!store.state.games.containsKey(game.id)) {
          // add to list to fetch
          idsToFetch.add(int.parse(game.id));
        }
      }

      if (idsToFetch.isNotEmpty) {
        // query igdb for all game ids
        // add all fetched games to state
        GameServiceClient client = new GameServiceClient();
        client.fetchGames(idsToFetch).then((games) {
          Map<String, GameModel> map = new Map.fromIterable(games,
              key: (game) => game.id,
              value: (game) => game
          );
          store.dispatch(new AddGamesCompleteAction(map));
        });
      }
    }
  });
}

_listenToNotes(Store<AppState> store, DocumentReference reference) {
  reference.getCollection(FirebaseNotesKey).snapshots.listen((QuerySnapshot event) {
    if (event != null) {
      event.documents.forEach((doc) {
        Note note = FirebaseModelUtils.noteFromSnapshot(doc);
        if (!store.state.notes.contains(note)) {
          store.dispatch(new AddNoteCompleteAction(note));
        }
      });
    }
  });
}

_listenToSessions(Store<AppState> store, DocumentReference reference) {
  reference.getCollection(FirebaseSessionsKey).snapshots.listen((QuerySnapshot event) {
    if (event != null) {
      event.documents.forEach((doc) {
        Session session = FirebaseModelUtils.sessionFromSnapshot(doc);
        if (!store.state.sessions.contains(session)) {
          store.dispatch(new AddSessionCompleteAction(session));
        }
      });
    }
  });
}

_logoutActionReducer(Store<AppState> store, action) async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  await firebaseAuth.signOut();
  store.dispatch(new LogoutCompleteAction());
}

_addGameActionReducer(Store<AppState> store, action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .getCollection(FirebaseCollectionKey)
      .document(action.game.id)
      .setData(FirebaseGame.fromGameModel(action.game).toMap());

  if (!store.state.games.containsKey(action.game.id)) {
    store.dispatch(new AddGameCompleteAction(action.game));
  }
}

_removeGameActionReducer(Store<AppState> store, action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .getCollection(FirebaseCollectionKey)
      .document(action.game.id)
      .delete();

  store.dispatch(new RemoveNotesCompleteAction(action.game.id));
  store.dispatch(new RemoveSessionsCompleteAction(action.game.id));
  store.dispatch(new RemoveGameCompleteAction(action.game));
}

_addNoteActionReducer(Store<AppState> store, action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .getCollection(FirebaseNotesKey)
      .document(action.note.dateCreated.toString())
      .setData(action.note.toMap());

  store.dispatch(new AddNoteCompleteAction(action.note));
}

_removeNoteActionReducer(Store<AppState> store, action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .getCollection(FirebaseNotesKey)
      .document(action.note.dateCreated.toString())
      .delete();

  store.dispatch(new RemoveNoteCompleteAction(action.note));
}

_startSessionActionReducer(Store<AppState> store, action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .setData({
    'currentActiveSession' : action.session.toMap()
  });

  store.dispatch(new StartSessionCompleteAction(action.session));
}
_endSessionActionReducer(Store<AppState> store, action) {
  Map<String, dynamic> data = {
    'currentActiveSession' : Session.getInactiveSession().toMap()
  };

  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .setData(data);

  Session newSession = new Session(
      gameId: store.state.currentActiveSession.gameId,
      dateStarted: store.state.currentActiveSession.dateStarted,
      dateEnded: action.dateEnded
  );

  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .getCollection(FirebaseSessionsKey)
      .document(store.state.currentActiveSession.dateStarted.toString())
      .setData(newSession.toMap());

  store.dispatch(new EndSessionCompleteAction(action.dateEnded));
}

_removeSessionActionReducer(Store<AppState> store, action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .getCollection(FirebaseSessionsKey)
      .document(action.session.dateStarted.toString())
      .delete();

  store.dispatch(new RemoveSessionCompleteAction(action.session));
}
