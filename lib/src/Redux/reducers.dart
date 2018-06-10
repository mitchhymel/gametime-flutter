part of gametime;

AppState stateReducer(AppState state, action) {
  if (action is InitActionComplete) {
    return state; // todo: things here?
  }
  else if (action is LoginCompleteAction) {
    return state.copyWith(
      firebaseUser: action.firebaseUser
    );
  }
  else if (action is LogoutCompleteAction) {
    return AppState.initialState();
  }
  else if (action is ChangeThemeAction) {
    return state.copyWith(
      theme: action.theme
    );
  }
  else if (action is ChangeRegionCompleteAction) {
    return state.copyWith(
      region: action.region,
    );
  }
  else if (action is AddGameCompleteAction) {
    return state.copyWith(
      games: <String, GameModel>{}
        ..addAll(state.games)
        ..putIfAbsent(action.game.id, () => action.game)
    );
  }
  else if (action is AddGamesCompleteAction) {
    Map<String, GameModel> newGames = {}..addAll(state.games);
    action.games.forEach((id, game) => newGames.putIfAbsent(id, () => game));
    return state.copyWith(
      games: newGames
    );
  }
  else if (action is RemoveGameCompleteAction) {
    Map<String, GameModel> gamesCopy = {}..addAll(state.games);
    gamesCopy.remove(action.game.id);

    return state.copyWith(
      games: gamesCopy,
    );
  }
  else if (action is AddNoteCompleteAction) {
    Map<String, List<Note>> newMap = {}..addAll(state.gameToNotes);
    if (state.gameToNotes.containsKey(action.note.gameId)) {
      List<Note> oldList = state.gameToNotes[action.note.gameId];
      newMap.remove(action.note.gameId);
      List<Note> newList = []..addAll(oldList)..add(action.note);
      newList.sort((a,b) => b.getDateTime().compareTo(a.getDateTime()));
      newMap.putIfAbsent(action.note.gameId, () => newList);
    }
    else {
      newMap.putIfAbsent(action.note.gameId, () => [action.note]);
    }

    return state.copyWith(
      gameToNotes: newMap
    );
  }
  else if (action is AddNotesCompleteAction) {
//    List<Note> newNotes = []..addAll(state.notes);
//    action.notes.forEach((Note note) {
//      if (!newNotes.contains(note)) {
//        newNotes.add(note);
//      }
//    });
//    return state.copyWith(
//      notes: newNotes
//    );
  }
  else if (action is RemoveNotesCompleteAction) {
    Map<String, List<Note>> mapCopy = {}..addAll(state.gameToNotes);
    mapCopy.remove(action.gameId);
    return state.copyWith(
        gameToNotes: mapCopy
    );
  }
  else if (action is RemoveNoteCompleteAction) {
    Map<String, List<Note>> mapCopy = {}..addAll(state.gameToNotes);
    List<Note> notesCopy = mapCopy[action.note.gameId];
    notesCopy.removeWhere((note) => note == action.note);
    mapCopy.remove(action.note.gameId);
    mapCopy.putIfAbsent(action.note.gameId, () => notesCopy);
    return state.copyWith(
        gameToNotes: mapCopy,
    );
  }
  else if (action is StartSessionCompleteAction) {
    return state.copyWith(
      currentActiveSession: action.session
    );
  }
  else if (action is EndSessionCompleteAction) {
    Session newSession = new Session(
        gameId: state.currentActiveSession.gameId,
        dateStarted: state.currentActiveSession.dateStarted,
        dateEnded: action.dateEnded
    );
    Map<String, List<Session>> copyMap = {}..addAll(state.gameToSessions);
    if (copyMap.containsKey(newSession.gameId)) {
      List<Session> oldList = copyMap[newSession.gameId];
      copyMap.remove(newSession.gameId);
      List<Session> newList = []..addAll(oldList)..add(newSession);
      newList.sort((a,b) => b.getDateTime().compareTo(a.getDateTime()));
      copyMap.putIfAbsent(newSession.gameId, () => newList);
    }
    else {
      copyMap.putIfAbsent(newSession.gameId, () => [newSession]);
    }

    return state.copyWith(
      currentActiveSession: new Session(
        gameId: ''
      ),
      gameToSessions: copyMap,
    );
  }
  else if (action is AddSessionCompleteAction) {
    Map<String, List<Session>> newMap = {}..addAll(state.gameToSessions);
    if (state.gameToSessions.containsKey(action.session.gameId)) {
      List<Session> oldList = state.gameToSessions[action.session.gameId];
      newMap.remove(action.session.gameId);
      List<Session> newList = []..addAll(oldList)..add(action.session);
      newList.sort((a,b) => b.getDateTime().compareTo(a.getDateTime()));
      newMap.putIfAbsent(action.session.gameId, () => newList);
    }
    else {
      newMap.putIfAbsent(action.session.gameId, () => [action.session]);
    }

    return state.copyWith(
      gameToSessions: newMap,
    );
  }
  else if (action is AddSessionsCompleteAction) {
//    List<Session> newSessions = []..addAll(state.sessions);
//    action.sessions.forEach((session) {
//      if (!newSessions.contains(session)) {
//        newSessions.add(session);
//      }
//    });
//
//    return state.copyWith(
//      sessions: newSessions
//    );
  }
  else if (action is AddActiveSessionAction) {
    return state.copyWith(
      currentActiveSession: action.session
    );
  }
  else if (action is RemoveSessionsCompleteAction) {
    Map<String, List<Session>> mapCopy = {}..addAll(state.gameToSessions);
    mapCopy.remove(action.gameId);
    return state.copyWith(
      gameToSessions: mapCopy
    );
  }
  else if (action is RemoveSessionCompleteAction) {
    Map<String, List<Session>> mapCopy = {}..addAll(state.gameToSessions);
    List<Session> listCopy = mapCopy[action.session.gameId];
    listCopy.removeWhere((session) => session == action.session);
    mapCopy.remove(action.session.gameId);
    mapCopy.putIfAbsent(action.session.gameId, () => listCopy);
    return state.copyWith(
      gameToSessions: mapCopy,
    );
  }

  return state;
}