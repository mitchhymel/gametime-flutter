part of gametime;

class GoogleCalendarClient {

  CalendarApi api;
  String _gameTimeCalendarId;
  static const String _GAMETIME_CALENDAR_NAME = 'Gametime - Release Dates';

  static final GoogleCalendarClient _singleton = new GoogleCalendarClient._internal();
  factory GoogleCalendarClient() {
    return _singleton;
  }

  GoogleCalendarClient._internal();

  init(GoogleSignInAccount gsa) async {
    final authHeaders = await gsa.authHeaders;
    final httpClient = new GoogleHttpClient(authHeaders);
    api = new CalendarApi(httpClient);
  }

  static Future<CalendarApi> _getApi() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/calendar'
        ]
    );

    GoogleSignInAccount gsa = await googleSignIn.signInSilently();
    if (gsa == null) {
      gsa = await googleSignIn.signIn();
    }
    final authHeaders = await gsa.authHeaders;
    final httpClient = new GoogleHttpClient(authHeaders);

    return new CalendarApi(httpClient);
  }

  Future<String> _getCalendarId() async {
    if (_gameTimeCalendarId != null) {
      return _gameTimeCalendarId;
    }

    CalendarList list = await api.calendarList.list();
    if (list.items.any((e) => e.summary == _GAMETIME_CALENDAR_NAME)) {
      _gameTimeCalendarId = list.items.firstWhere((e) => e.summary == _GAMETIME_CALENDAR_NAME).id;
      return _gameTimeCalendarId;
    }

    Calendar calendar = new Calendar();
    calendar.summary = _GAMETIME_CALENDAR_NAME;
    Calendar newCalendar = await api.calendars.insert(calendar);

    return newCalendar.id;
  }

  Future<Event> createEvent(GameModel game, ReleaseDate releaseDate) async {
    debugPrint('${game.name} - ${releaseDate.date}');

    String calendarId = await _getCalendarId();
    if (calendarId == null) {
      debugPrint('calendarid was null');
      return null;
    }

    Event event = new Event();
    event.summary = '${game.name} released on ${releaseDate.platform.name}';
    EventDateTime start = new EventDateTime();
    start.date = releaseDate.date;
    EventDateTime end = new EventDateTime();
    end.date = releaseDate.date.add(new Duration(days: 1));
    event.start = start;
    event.end = end;
    var createdEvent = await api.events.insert(event, calendarId);
    debugPrint(createdEvent.htmlLink);

    return createdEvent;
  }
}