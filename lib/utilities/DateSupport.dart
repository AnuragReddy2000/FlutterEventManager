import 'package:intl/intl.dart';

class DateSupport{
  static String getDay(String dateinp){
    DateFormat dateFormat = DateFormat.EEEE();
    DateTime date = DateTime.parse(dateinp);
    return dateFormat.format(date);
  }

  static String getDate(String dateinp){
    DateFormat dateFormat = DateFormat.yMMMMd();
    DateTime date = DateTime.parse(dateinp);
    return dateFormat.format(date);
  }

  static String getTime(String dateinp,String timeinp){
    DateFormat dateFormat = DateFormat.jm();
    DateTime date = DateTime.parse(dateinp + ' '+ timeinp);
    return dateFormat.format(date);
  }

  static String makeID(DateTime datetime){
    String id = DateFormat('MMdd').format(datetime) + DateFormat('HH').format(datetime) + DateFormat('mm').format(datetime) + DateFormat('ss').format(datetime);
    return id;
  }
}