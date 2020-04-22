import 'package:intl/intl.dart';

class DateSupport{
  static String getDay(List<String> inp){
    DateFormat dateFormat = DateFormat.EEEE();
    DateTime date = DateTime.parse(inp[2]);
    return dateFormat.format(date);
  }

  static String getdate(List<String> inp){
    DateFormat dateFormat = DateFormat.yMMMMd();
    DateTime date = DateTime.parse(inp[2]);
    return dateFormat.format(date);
  }

  static String getTime(List<String> inp){
    DateFormat dateFormat = DateFormat.jm();
    DateTime date = DateTime.parse(inp[2] + ' '+ inp[3]);
    return dateFormat.format(date);
  }
}