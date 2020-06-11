import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_event_manager/models/EventsModel.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';

class Reminder{

  static void showReminder(BuildContext context, List<String> inputdata, EventsModel myEventsModel) async {
    showDialog(context: context,
    builder: (context){
      return StatefulBuilder(builder: (context,setState){
        Timer(Duration(minutes: 5), (){
          if(inputdata[5] == 'false' && inputdata[6] == 'Normal'){
            myEventsModel.recievedReminder(inputdata[0]);
          }
          else{
            myEventsModel.getData();
          }
          ChannelTasks.endReminder();
          ChannelTasks.removeFromLockscreen();
          ChannelTasks.sendNotification(inputdata);
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return GestureDetector(
          onPanUpdate: (details) {
            if(details.delta.dy < 0){
              if(inputdata[5] == 'false' && inputdata[6] == 'Normal'){
                myEventsModel.recievedReminder(inputdata[0]);
              }
              else{
                myEventsModel.getData();
              }
              ChannelTasks.endReminder();
              Navigator.pop(context);
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
              (inputdata[6] == 'Notification') ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(child: Text('Back',style: TextStyle(color: Colors.blue[200],)), 
                    padding: EdgeInsets.all(1),
                    onPressed: (){
                      ChannelTasks.removeFromLockscreen();
                      Navigator.pop(context);
                    }, 
                  ),
                  FlatButton(child: Text('Close',style: TextStyle(color: Colors.blue[200],)), 
                    padding: EdgeInsets.all(1),
                    onPressed: (){
                      ChannelTasks.removeFromLockscreen();
                      Navigator.pop(context);
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    }, 
                  )
                ],
              )
              :
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(child: Text('Leave a Notification',style: TextStyle(color: Colors.blue[200],)), 
                        padding: EdgeInsets.all(1),
                        onPressed: (){
                          ChannelTasks.endReminder();
                          if(inputdata[5] == 'false' && inputdata[6] == 'Normal'){
                            myEventsModel.recievedReminder(inputdata[0]);
                          }
                          else{
                            myEventsModel.getData();
                          }
                          ChannelTasks.removeFromLockscreen();
                          ChannelTasks.sendNotification(inputdata);
                          Navigator.pop(context);
                        }, 
                      ),
                      FlatButton(child: Text('Back',style: TextStyle(color: Colors.blue[200],)), 
                        padding: EdgeInsets.all(1),
                        onPressed: (){
                          ChannelTasks.endReminder();
                          if(inputdata[5] == 'false' && inputdata[6] == 'Normal'){
                            myEventsModel.recievedReminder(inputdata[0]);
                          }
                          else{
                            myEventsModel.getData();
                          }
                          ChannelTasks.removeFromLockscreen();
                          Navigator.pop(context);
                        }, 
                      ),
                      FlatButton(child: Text('Snooze',style: TextStyle(color: Colors.blue[200],)), 
                        padding: EdgeInsets.all(1),
                        onPressed: (){
                          ChannelTasks.snooze(inputdata);
                          ChannelTasks.endReminder();
                          if(inputdata[5] == 'false' && inputdata[6] == 'Normal'){
                            myEventsModel.recievedReminder(inputdata[0]);
                          }
                          else{
                            myEventsModel.getData();
                          }
                          ChannelTasks.removeFromLockscreen();
                          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        }, 
                      ),
                    ],
                  ),
                  Text('Swipe up to dismiss',style:  TextStyle(color: Colors.white,))
                ],
              )
            ],
          ),
        );
      });
    },
    barrierDismissible: false
    );
  }


}