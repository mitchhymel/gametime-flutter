part of gametime;


//region Theme actions
class ChangeThemeAction {
  final CustomTheme theme;
  ChangeThemeAction({this.theme});
}
//endregion

//region Account actions

class InitAction {
  InitAction();
}

class InitActionComplete {
  InitActionComplete();
}

class LoginAction {
  final Function onLoginSuccess;
  final Function onLoginError;
  LoginAction({this.onLoginSuccess, this.onLoginError});
}

class LoginCompleteAction {
  final FirebaseUser firebaseUser;
  final GoogleSignInAccount googleUser;
  LoginCompleteAction(this.firebaseUser, this.googleUser);
}

class LogoutAction {
  LogoutAction();
}

class LogoutCompleteAction {
  LogoutCompleteAction();
}

class ChangeRegionAction {
  final Regions region;
  ChangeRegionAction(this.region);
}

class ChangeRegionCompleteAction {
  final Regions region;
  ChangeRegionCompleteAction(this.region);
}

//endregion

//region Collection actions

class AddGameAction {
  final GameModel game;
  AddGameAction(this.game);

  @override
  String toString() {
    return '{"game": ${game.toString()}}';
  }
}

class AddGameCompleteAction {
  final GameModel game;
  AddGameCompleteAction(this.game);

  @override
  String toString() {
    return '{"game": ${game.toString()}}';
  }
}

class AddGamesCompleteAction {
  final Map<String, GameModel> games;
  AddGamesCompleteAction(this.games);

  @override
  String toString() {
    return '{"games": ${games.toString()}}';
  }
}

class RemoveGameAction {
  final GameModel game;
  RemoveGameAction(this.game);
}

class RemoveGameCompleteAction {
  final GameModel game;
  RemoveGameCompleteAction(this.game);
}
//endregion

//region Note actions

class AddNoteAction {
  final GameModel game;
  final Note note;
  AddNoteAction(this.game, this.note);
}

class AddNoteCompleteAction {
  final Note note;
  AddNoteCompleteAction(this.note);
}

class AddNotesCompleteAction {
  final List<Note> notes;
  AddNotesCompleteAction(this.notes);
}

class RemoveNoteAction {
  final Note note;
  RemoveNoteAction(this.note);
}

class RemoveNoteCompleteAction {
  final Note note;
  RemoveNoteCompleteAction(this.note);
}

class RemoveNotesCompleteAction {
  final String gameId;
  RemoveNotesCompleteAction(this.gameId);
}
//endregion

//region Session actions

class StartSessionAction {
  final Session session;
  StartSessionAction(this.session);
}

class StartSessionCompleteAction {
  final Session session;
  StartSessionCompleteAction(this.session);
}

class EndSessionAction {
  final DateTime dateEnded;
  EndSessionAction(this.dateEnded);
}

class EndSessionCompleteAction {
  final DateTime dateEnded;
  EndSessionCompleteAction(this.dateEnded);
}

class AddSessionCompleteAction {
  final Session session;
  AddSessionCompleteAction(this.session);
}

class AddSessionsCompleteAction {
  final List<Session> sessions;
  AddSessionsCompleteAction(this.sessions);
}

class AddActiveSessionAction {
  final Session session;
  AddActiveSessionAction(this.session);
}

class RemoveSessionsCompleteAction {
  final String gameId;
  RemoveSessionsCompleteAction(this.gameId);
}

class RemoveSessionAction {
  final Session session;
  RemoveSessionAction(this.session);
}

class RemoveSessionCompleteAction {
  final Session session;
  RemoveSessionCompleteAction(this.session);
}
//endregion

//region Feed actions

//endregion

