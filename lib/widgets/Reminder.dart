import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';

class Reminder{

  static void showReminder(BuildContext context, List<String> details) async {
    showDialog(context: context,
    builder: (context){
      bool isLoading = true;
      return StatefulBuilder(builder: (context,setState){
        if(details[3] == 'false'){
          FlutterRingtonePlayer.playAlarm();
          Timer(Duration(minutes: 5), (){
            FlutterRingtonePlayer.stop();
            ChannelTasks.sendNotification();
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
          });
        }
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 23, 30, 39),
          title: Text('Reminder For, '+ DateSupport.getTime(details[1],details[2]) + ' ' + DateSupport.getDay(details[1]) +' '+ DateSupport.getDate(details[1]),
            style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),
            textAlign: TextAlign.left,
          ),
          content: Text(details[0],
            style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            FlatButton(child: Text('Dismiss',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],))), 
              onPressed: (){
                if(details[3] == 'false'){
                  FlutterRingtonePlayer.stop();
                }
                Navigator.pop(context,(){});
              }, 
            ),
          ],
        );
      });
    },
    barrierDismissible: false
    );
  }


}