import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';

class NotesInput{
  static final _formKey = GlobalKey<FormState>();
  static String title;
  static String text;

  static void notesInput(BuildContext context) async {
    await showDialog(context: context, 
      builder: (_) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        title: Text('Add new note ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Title: ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top:5,bottom:5),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              ) 
                            ),
                            errorStyle: TextStyle(color: Colors.red),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              ) 
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSaved: (value) => title = value,
                          validator: (value) => value.isEmpty ? 'This field must be filled' : null,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right:5,top: 10,bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text('Body: ',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white,)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:5,bottom:5),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height)*0.2,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.0),
                        borderSide: BorderSide(
                          color: Colors.white54
                        ),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.0),
                        borderSide: BorderSide(
                          color: Colors.white
                        ) 
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    onSaved: (value) => text = value,
                    validator: (value) => value.isEmpty ? 'This field must be filled' : null,
                  ),
                ),
              ],
            )
          ),
        ),
        actions: <Widget>[
          FlatButton(child: Text('Save Note',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],))),
            onPressed: (){
              if (_formKey.currentState.validate()){
                _formKey.currentState.save();
                DBQueries.insertNote(title, text);
                Navigator.pop(context);
              }
            },
          ),
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))), 
        ],
      ),
      barrierDismissible: true,
    );
  }
}