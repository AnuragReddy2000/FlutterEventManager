import 'package:flutter/services.dart';

class ChannelTasks{

  static const platform = const MethodChannel('event_manager.flutter.dev/alarm');
  static void setAlarm(List<String> inp) async {
    String res = await platform.invokeMethod('setAlarm',input(inp));
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