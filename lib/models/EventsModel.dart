import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';
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
        style: TextStyle(fontSize: 18, color: Colors.white54),
        textAlign: TextAlign.center,
      );
    }
    else{
      upcomingevents = ListView(padding: EdgeInsets.only(bottom: 10),children: events);
    }
    isLoading = false;
    notifyListeners();
  }

  void saveEvent(List<String> input) async {
    var datetime = DateTime.now();
    input.insert(0, DateSupport.makeID(datetime));
    await DBQueries.insertRow(input);
    ChannelTasks.setAlarm(input);
    getData();
  }  

  void deleteEvent(List<String> inp) async {
    await DBQueries.deleteRow(inp[0]);
    ChannelTasks.cancelAlarm(inp);
    getData();
  }

  void recievedReminder(String id) async {
    await DBQueries.deleteRow(id);
    getData();
  }
}