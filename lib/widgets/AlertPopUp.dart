import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';

class AlertPopUp {
  static void alertBox(BuildContext context, List<String> inp, String type, Function onDelete) async {
    await showDialog(context: context,
      builder: (context) {
        String det = 'less';
        return StatefulBuilder(
          builder: (context,setState){
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 23, 30, 39),
              title: (type == 'note') ? 
              Text(inp[1],
                style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),
              )
              : 
              Text('Reminder For, '+ DateSupport.getTime(inp) + ' ' + DateSupport.getDay(inp) +' '+ DateSupport.getdate(inp),
                style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: (type == 'note') ? 
                  [Text(inp[2],
                    style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
                  )]
                  :
                  _getChildern(det, inp),
                ),
              ),
              actions: (type == 'note') ? [FlatButton(onPressed: (){delete(inp,context,onDelete,type);}, child: Text('Delete',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
                FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),] 
              : 
              (det == 'more') ? [FlatButton(onPressed: (){delete(inp,context,onDelete,type);}, child: Text('Delete',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
                FlatButton(onPressed: (){setState(() {det = "less";});}, child: Text('Less Details',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)),)),
                FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),] 
                :
                [ FlatButton(onPressed: (){delete(inp,context,onDelete,type);}, child: Text('Delete',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
                FlatButton(onPressed: (){setState(() {det = "more";});}, child: Text('More Details',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)),)),
                FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),]
            );
          }
        );
      },
      barrierDismissible: true,
    );
  }

  static List<Widget> _getChildern(String def,List<String> inp){
    if(def == 'less'){
      return [Text(inp[1],
        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
      )];
    }
    else if(def == 'more'){
      return [
        Container(
          margin: EdgeInsets.only(bottom : 15),
          child: Text(inp[1],style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),)
        ),
        Container(
          margin: EdgeInsets.only(bottom : 5),
          child: Text('Reminder Mode: ' + ((inp[4] == 'false') ? 'Ring Alert': 'Silent Notification'),style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 16, color: Colors.white,)),)
        ),
        Container(
          margin: EdgeInsets.only(bottom : 5),
          child: Text('Reminder Type: ' + ((inp[5] == 'false') ? 'One-Time Alert': 'Repeating Alarm'),style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 16, color: Colors.white,)),)
        )
      ];
    }
  }

  static void delete(List<String> inp, BuildContext context,Function onDelete,String type) async {
    String result = await showDialog(context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Confirmation:',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),),
        content: Text('Delete this ' + ((type == 'note') ? 'note?' : 'reminder?'),style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white,)),),
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        actions: <Widget>[
          FlatButton(onPressed: (){Navigator.pop(context,"no");}, child: Text('No',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
          FlatButton(onPressed: (){Navigator.pop(context,"yes");}, child: Text('Yes',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
        ],
      ),
      barrierDismissible: false,
    );
    if(result == "yes"){
      if(type == 'note'){
        DBQueries.deleteNote(inp[0]);
      }
      //ChannelTasks.deleteAlarm(inp[0]);
      onDelete();
      Navigator.pop(context);
    }
  }
}