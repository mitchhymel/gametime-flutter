part of gametime;

class DateTimeHelper {

  static String getDateTimeInHoursMins(DateTime time) {
    return '${time.hour%12}:${time.minute >= 10 ? time.minute : '0' + time.minute.toString()} ${time.hour/12 > 1 ? 'PM' : 'AM'}';
  }

  static String getMonthDay(DateTime time) {
    return '${time.month}/${time.day}';
  }

  static String getDurationInHoursMins(Duration time) {
    if (time.inMinutes >= 60) {
      String hours = '${time.inHours}';
      int mins = time.inMinutes~/60;
      String minutes = '${mins >= 10 ? mins : '0$mins'}';
      return '$hours:$minutes';
    }
    else {
      return '0:${time.inMinutes}';
    }
  }
}
