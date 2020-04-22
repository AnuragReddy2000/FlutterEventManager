import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';

class AlertPopUp {
  static void alertBox(BuildContext context, List<String> inp, String type) async {
    Function showMsg = await showDialog(context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        title: Text('Reminder For, '+ DateSupport.getTime(inp) + ' ' + DateSupport.getDay(inp) +' '+ DateSupport.getdate(inp),
          style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),
        ),
        content: Text(inp[1],
          style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
        ),
        actions: <Widget>[
          (type == 'alarm') ? FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Dismiss')) 
          :
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Properties')),
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back')),
          FlatButton(onPressed: (){delete(inp,context);}, child: Text('Delete')),
        ],
      ),
      barrierDismissible: true,
    );
    showMsg();
  }

  static void delete(List<String> inp, BuildContext context) async {
    Function confirm = await showDialog(context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Confirmation:',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),),
        content: Text('Delete this reminder?',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white,)),),
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        actions: <Widget>[
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('No')),
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Yes')),
        ],
      ),
      barrierDismissible: false,
    );
    confirm();
  }

  static void properties(List<String> inp, BuildContext context) async {
    Function show = await showDialog(context: context,
      builder: (_) => AlertDialog(
        title: Text('Reminder Properties:',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),),
        content: Text('Reminder Date: ' + DateSupport.getTime(inp) + ' ' + DateSupport.getDay(inp) +' '+ DateSupport.getdate(inp),
          style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white,)),
        ),
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        actions: <Widget>[
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back')),
        ],
      ),
      barrierDismissible: false,
    );
    show();
  }
}