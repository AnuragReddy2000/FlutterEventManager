import 'package:flutter/services.dart';

class ChannelTasks {

  static const MethodChannel channel = MethodChannel('com.example.virtual_event_manager.platform_channel');

  static void setAlarm(List<String> inp) async {
    String res = await channel.invokeMethod('setAlarm(call)',input(inp));
    print(res);
  }

  static void cancelAlarm(List<String> inp) async {
    await channel.invokeMethod('cancelAlarm(call)',input(inp));
  }

  static void snooze(List<String> inp) async {
    await channel.invokeMethod('snooze(call)',input(inp));
  }

  static void endReminder() async {
    await channel.invokeMethod('endReminder');
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

  static Future<List<String>> getReminderData() async {
    String reminderdata = await channel.invokeMethod('getReminderDetails(intentdata)');
    List<String> details = reminderdata.split(",");
    return details;
  }

  static void sendNotification(List<String> inp) async {
    await channel.invokeMethod('sendNotification(call)',input(inp));
  }

  static void removeFromLockscreen() async {
    await channel.invokeMethod('removeFromLockscreen');
  }

}

