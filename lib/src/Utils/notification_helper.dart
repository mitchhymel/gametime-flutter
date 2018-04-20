part of gametime;

class NotificationHelper {
  static const _notificationId = 0;

  static const AndroidNotificationChannel _channel = const AndroidNotificationChannel(
      id: 'gametime_notifications',
      name: 'Active session',
      description: 'Indicates if there is an active session',
      importance: AndroidNotificationChannelImportance.LOW,
      vibratePattern: AndroidVibratePatterns.NONE,
  );

  static Future<Null> initialize() async {
    // await LocalNotifications.setLogging(true);
    await LocalNotifications.createAndroidNotificationChannel(channel: _channel);
  }

  static Future<Null> createNotification(GameModel game,
      DateTime startTime, VoidCallback notifCallback) async {
    String startTimeStr = DateTimeHelper.getDateTimeInHoursMins(new DateTime.now());

    await LocalNotifications.createNotification(
        title: game.name,
        content: 'Started playing at $startTimeStr',
        imageUrl: game.imageUrl,
        id: _notificationId,
        androidSettings: new AndroidSettings(
          isOngoing: true,
          channel: _channel,
          priority: AndroidNotificationPriority.LOW,
          vibratePattern: AndroidVibratePatterns.NONE,
        ),
        actions: [
          new NotificationAction(
            actionText: 'Stop',
            payload: '${game.toString()}',
            launchesApp: false,
            callbackName: 'notification_callback',
            callback: (String text) async {
              await NotificationHelper.removeNotification();
              notifCallback();
            }
          )
        ]
    );
  }
  static Future<Null> removeNotification() async {
    await LocalNotifications.removeNotification(_notificationId);
  }
}
