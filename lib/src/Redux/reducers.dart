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
    Map<String, GameModel> copy = state.games;
    copy.remove(action.game.id);
    return state.copyWith(
      games: <String, GameModel>{}
        ..addAll(copy)
    );
  }
  else if (action is AddNoteCompleteAction) {
    List<Note> newNotes = []..addAll(state.notes);
    if (!newNotes.contains(action.note)) {
      newNotes.add(action.note);
    }
    return state.copyWith(
      notes: newNotes
    );
  }
  else if (action is AddNotesCompleteAction) {
    List<Note> newNotes = []..addAll(state.notes);
    action.notes.forEach((Note note) {
      if (!newNotes.contains(note)) {
        newNotes.add(note);
      }
    });
    return state.copyWith(
      notes: newNotes
    );
  }
  else if (action is RemoveNotesCompleteAction) {
    List<Note> copy = []..addAll(state.notes);
    copy.removeWhere((note) => note.gameId == action.gameId);
    return state.copyWith(
      notes: []
          ..addAll(copy)
    );
  }
  else if (action is RemoveNoteCompleteAction) {
    List<Note> copyNotes = []..addAll(state.notes);
    copyNotes.removeWhere((note) => note == action.note);
    return state.copyWith(
        notes: []..addAll(copyNotes)
    );
  }
  else if (action is StartSessionCompleteAction) {
    return state.copyWith(
      currentActiveSession: action.session
    );
  }
  else if (action is EndSessionCompleteAction) {
    return state.copyWith(
      currentActiveSession: new Session(
        gameId: ''
      ),
      sessions: []
        ..addAll(state.sessions)
        ..add(new Session(
            gameId: state.currentActiveSession.gameId,
            dateStarted: state.currentActiveSession.dateStarted,
            dateEnded: action.dateEnded
          )
        )
    );
  }
  else if (action is AddSessionCompleteAction) {
    List<Session> newSessions = []..addAll(state.sessions);
    if (!newSessions.contains(action.session)) {
      newSessions.add(action.session);
    }

    return state.copyWith(
      sessions: newSessions
    );
  }
  else if (action is AddSessionsCompleteAction) {
    List<Session> newSessions = []..addAll(state.sessions);
    action.sessions.forEach((session) {
      if (!newSessions.contains(session)) {
        newSessions.add(session);
      }
    });

    return state.copyWith(
      sessions: newSessions
    );
  }
  else if (action is AddActiveSessionAction) {
    return state.copyWith(
      currentActiveSession: action.session
    );
  }
  else if (action is RemoveSessionsCompleteAction) {
    List<Session> copySessions = state.sessions;
    copySessions.removeWhere((session) => session.gameId == action.gameId);
    return state.copyWith(
      sessions: []
          ..addAll(copySessions)
    );
  }
  else if (action is RemoveSessionCompleteAction) {
    List<Session> copySessions = state.sessions;
    copySessions.removeWhere((session) => session == action.session);
    return state.copyWith(
        sessions: []..addAll(copySessions)
    );
  }

  return state;
}