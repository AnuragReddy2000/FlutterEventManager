import 'package:flutter/services.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';

class ChannelTasks{

  static const platform = const MethodChannel('com.flutter.event.alarm');

  static void setAlarm(List<String> inp) async {
    String res = await platform.invokeMethod('setAlarm');
    print(res);
  }

  static Map<String,dynamic> input(List<String> inp){
    Map<String, dynamic> args = <String, dynamic>{};
    args['Id'] = inp[0];
    args['Text'] = inp[1];
    args['Date'] = inp[2];
    args['Time'] = inp[3];
    args['Silent'] = inp[4];
    args['Repeat'] = inp[5];
    return args;
  }

}