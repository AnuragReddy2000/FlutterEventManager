import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:virtual_event_manager/models/EventsModel.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';

class Reminder{

  static void showReminder(BuildContext context, List<String> inputdata, EventsModel myEventsModel) async {
    showDialog(context: context,
    builder: (context){
      return StatefulBuilder(builder: (context,setState){
        if(inputdata[4] == 'false'){
          FlutterRingtonePlayer.playAlarm();
        }
        if(inputdata[5] == 'false'){
          myEventsModel.recievedReminder(inputdata[0]);
        }
        else{
          myEventsModel.getData();
        }
        Timer(Duration(minutes: 5), (){
          if(inputdata[4] == 'false'){
            FlutterRingtonePlayer.stop();
          }
          ChannelTasks.sendNotification(inputdata);
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return GestureDetector(
          onPanUpdate: (details) {
            if(details.delta.dy < 0){
              if(inputdata[4] == 'false'){
                FlutterRingtonePlayer.stop();
              }
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          },
          child:  AlertDialog(
            backgroundColor: Color.fromARGB(255, 23, 30, 39),
            title: Text('Reminder For, '+ DateSupport.getTime(inputdata[2],inputdata[3]) + ' ' + DateSupport.getDay(inputdata[2]) +' '+ DateSupport.getDate(inputdata[2]),
              style: TextStyle(fontSize: 22, color: Colors.blue[200],),
              textAlign: TextAlign.left,
            ),
            content: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.4),
              child: SingleChildScrollView(
                child: Text(inputdata[1],
                  style: TextStyle(fontSize: 20, color: Colors.white,),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            actions: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(child: Text('Leave a Notification',style: TextStyle(color: Colors.blue[200],)), 
                        onPressed: (){
                          ChannelTasks.sendNotification(inputdata);
                          if(inputdata[4] == 'false'){
                            FlutterRingtonePlayer.stop();
                          }
                          Navigator.pop(context);
                        }, 
                      ),
                      FlatButton(child: Text('Back',style: TextStyle(color: Colors.blue[200],)), 
                        onPressed: (){
                          if(inputdata[4] == 'false'){
                            FlutterRingtonePlayer.stop();
                          }
                          Navigator.pop(context);
                        }, 
                      ),
                      FlatButton(child: Text('Snooze',style: TextStyle(color: Colors.blue[200],)), 
                        onPressed: (){
                          ChannelTasks.snooze(inputdata);
                          if(inputdata[4] == 'false'){
                            FlutterRingtonePlayer.stop();
                          }
                          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        }, 
                      ),
                    ],
                  ),
                  Text('Swipe up to dismiss',style:  TextStyle(color: Colors.white,))
                ],
              ),
            ],
          ),
        );
      });
    },
    barrierDismissible: false
    );
  }


}