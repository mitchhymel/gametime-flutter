part of gametime;

const String FirebaseUsersKey = 'users';
const String FirebaseCollectionKey = 'collection';
const String FirebaseNotesKey = 'notes';
const String FirebaseSessionsKey = 'sessions';
const String FirebaseCurrentActiveSessionFieldKey = 'currentActiveSession';
const String FirebaseUserRegionFieldKey = 'region';

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
  else if (action is ChangeRegionAction) {
    _changeRegionActionReducer(store, action);
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
  GoogleSignInAccount gsa = store.state.googleUser ;
  if (gsa == null) {
    final GoogleSignIn _googleSignIn = new GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/calendar'
        ]
    );
    gsa = await _googleSignIn.signInSilently();
    if (gsa == null) {
      debugPrint('Failed to sign into Google silently');
      return;
    }
  }

  FirebaseUser fbUser = store.state.firebaseUser;
  if (fbUser == null) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    fbUser = await auth.currentUser();
    if (fbUser == null) {
      final GoogleSignInAuthentication gAuth = await gsa.authentication;
      fbUser = await auth.signInWithGoogle(
          idToken: gAuth.idToken,
          accessToken: gAuth.accessToken
      );

      if (fbUser == null) {
        debugPrint('Failed to sign into Firebase with Google creds');
        return;
      }
    }
  }

  store.dispatch(new LoginCompleteAction(fbUser, gsa));
}

_loginActionReducer(Store<AppState> store, action) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/calendar'
      ]
  );
  final GoogleSignInAccount gUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication gAuth = await gUser.authentication;
  final FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken
  );

  debugPrint('logged in as user ${user.uid}');

  store.dispatch(new LoginCompleteAction(user, gUser));
}

_loginCompleteActionReducer(Store<AppState> store, action) {
  DocumentReference reference = Firestore.instance
      .collection(FirebaseUsersKey)
      .document(action.firebaseUser.uid);


  _listenToCollection(store, reference);
  _listenToActiveSession(store, reference);
  _listenToNotes(store, reference);
  _listenToSessions(store, reference);
}

_listenToActiveSession(Store<AppState> store, DocumentReference reference) {
  reference.snapshots.listen((DocumentSnapshot event){
    if (event != null) {
      Map persistedValue = event.data[FirebaseCurrentActiveSessionFieldKey];
      if (persistedValue != null) {
        Session activeSession = Session.fromMap(persistedValue);
        if (activeSession.isValidActiveSession()) {
          store.dispatch(new AddActiveSessionAction(activeSession));
        }
      }

      int regionId = event.data[FirebaseUserRegionFieldKey];
      if (regionId != null) {
        store.dispatch(new ChangeRegionCompleteAction(Regions.fromInt(regionId)));
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
        if (!store.state.gameToNotes.containsKey(note.gameId)
            || !store.state.gameToNotes[note.gameId].contains(note)) {
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

        if (!store.state.gameToSessions.containsKey(session.gameId)
            || !store.state.gameToSessions[session.gameId].contains(session)) {
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

_changeRegionActionReducer(Store<AppState> store, ChangeRegionAction action) {
  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .updateData({'region': action.region.id});

  store.dispatch(new ChangeRegionCompleteAction(action.region));
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
      .updateData({
    FirebaseCurrentActiveSessionFieldKey : action.session.toMap()
  });

  store.dispatch(new StartSessionCompleteAction(action.session));
}

_endSessionActionReducer(Store<AppState> store, action) {
  Map<String, dynamic> data = {
    FirebaseCurrentActiveSessionFieldKey : Session.getInactiveSession().toMap()
  };

  Firestore.instance
      .collection(FirebaseUsersKey)
      .document(store.state.firebaseUser.uid)
      .updateData(data);

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
