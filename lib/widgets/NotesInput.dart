import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesInput{
  static final _formKey = GlobalKey<FormState>();

  static void notesInput(BuildContext context,Function saveNote) async {
    String title;
    String text;
    await showDialog(context: context, 
      builder: (_) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        title: Text('Add new note ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text('Title: ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.only(left: 5,right: 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.red),
                      enabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (value) => title = value,
                    validator: (value) => value.isEmpty ? 'This field must be filled' : null,
                  ),
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
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(
                          color: Colors.white54
                        ),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
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
                saveNote(title,text);
                Navigator.pop(context);
              }
            },
          ),
          FlatButton(onPressed: (){Navigator.pop(context,(){});}, child: Text('Back',style: GoogleFonts.quicksand(textStyle: TextStyle(color: Colors.blue[200],)))), 
        ],
      ),
      barrierDismissible: false,
    );
  }
}