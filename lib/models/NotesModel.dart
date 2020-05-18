import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/widgets/NotesCarousel.dart';

class NotesModel with ChangeNotifier{
  Widget notes;
  bool isLoading = true;

  NotesModel(){
    getData();
  }

  void getData() async {
    List<List<String>> data;
    isLoading = true;
    data = await DBQueries.getNotes();
    isLoading = false;
    (data.length == 0) ? notes = Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text('You haven\'t written any!',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white54)),textAlign: TextAlign.center,)
      )
    )
    : notes = Expanded(child: NotesCarousel(input: data));
    notifyListeners();
  }

  void saveNote(String title,String text) async {
    await DBQueries.insertNote(title, text);
    getData();
  }

  void deleteNote(String id) async {
    await DBQueries.deleteNote(id);
    getData();
  }

  void editNote(String id, String title, String text) async {
    await DBQueries.editNotes(id, title, text);
    getData();
  }
}