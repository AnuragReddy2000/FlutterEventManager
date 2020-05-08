import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/widgets/EventsList.dart';

class EventsModel with ChangeNotifier{
  Widget upcomingevents;
  bool isLoading = true;

  EventsModel(){
    getData();
  }

  void getData() async {
    isLoading = true;
    List<List<String>> data = await DBQueries.getEvents();
    List<Widget> events = List();
    for(var i = 0; i<data.length; i++){
      events.add(EventsList(inp: data[i]));
    }
    if(data.length == 0){
      upcomingevents = Text('No Upcoming Events!',
        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white54)),
        textAlign: TextAlign.center,
      );
    }
    else{
      upcomingevents = ListView(children: events);
    }
    isLoading = false;
    notifyListeners();
  }

  void saveEvent(List<String> input) async {
    await DBQueries.insertRow(input);
    getData();
  }  

  void deleteEvent(String id) async {
    await DBQueries.deleteRow(id);
    getData();
  }
}