import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_manager/models/NotesModel.dart';

class Notes extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(150, 41, 43, 50),
        border: Border(top: BorderSide(width: 1, color: Colors.blue[200])),
      ),  
      margin: EdgeInsets.only(top:10),
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Notes: ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),textAlign: TextAlign.center,),
          Consumer<NotesModel>(
            builder: (context,myNotesModel,child){
              return myNotesModel.isLoading ? Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Please wait...',
                    style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white54)),
                    textAlign: TextAlign.center,
                  )
                )
              )
              : 
              myNotesModel.notes;
            }
          )
        ],
      ),
    );
  }
}
