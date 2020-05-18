import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';

import 'NotesInput.dart';

class AlertPopUp {

  static void alertBox(BuildContext context, List<String> inp, String type, Function onDelete, {Function editNote}) async {
    await showDialog(context: context,
      builder: (context) {
        String details = 'less';
        return StatefulBuilder(
          builder: (context,setState){
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 23, 30, 39),
              title: (type == 'note') ? 
              Text(inp[1],
                style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),
              )
              : 
              Text('Reminder For, '+ DateSupport.getTime(inp[2],inp[3]) + ' ' + DateSupport.getDay(inp[2]) +' '+ DateSupport.getDate(inp[2]),
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
                  _getChildern(details, inp),
                ),
              ),
              actions: <Widget>[
                FlatButton(onPressed: (){delete(inp,context,onDelete,type);}, child: Text('Delete',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
                ((type == 'note') ? FlatButton(onPressed: (){NotesInput.notesInput(context,id: inp[0],initialtitle: inp[1],initialtext: inp[2],editNote: editNote,type: 'edit');}, child: Text('Edit',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],))))
                 : ((details == 'more') ? FlatButton(onPressed: (){setState(() {details = "less";});}, child: Text('Less Details',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)),))
                  : FlatButton(onPressed: (){setState(() {details = "more";});}, child: Text('More Details',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)),)))
                ),
                FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))),
              ]
            );
          }
        );
      },
      barrierDismissible: true,
    );
  }

  static List<Widget> _getChildern(String details,List<String> inp){
    if(details == 'less'){
      return [Text(inp[1],
        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
      )];
    }
    else if(details == 'more'){
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
          child: Text('Repeat: ' + inp[5],style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 16, color: Colors.white,)),)
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
      onDelete(inp[0]);
      Navigator.pop(context);
    }
  }
}