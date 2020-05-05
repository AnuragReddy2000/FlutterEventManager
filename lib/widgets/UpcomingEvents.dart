import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/widgets/EventsList.dart';

class UpcomingEvents extends StatefulWidget{

  @override 
  UpcomingEventsState createState() => UpcomingEventsState();
}

class UpcomingEventsState extends State<UpcomingEvents>{
  bool isLoading = true;
  Widget upcomingEvents;

  void getData() async {
    List<List<String>> data = await DBQueries.getEvents();
    List<Widget> events = List();
    for(var i = 0; i<data.length; i++){
      events.add(EventsList(inp: data[i],callBack: getData));
    }
    if(data.length == 0){
      upcomingEvents = Text('No Upcoming Events!',
        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white54)),
        textAlign: TextAlign.center,
      );
    }
    else{
      upcomingEvents = ListView(children: events);
    }
    setState(() => {
      isLoading = false,
    });
  }

  @override 
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 10, right: 10),
          height: MediaQuery.of(context).size.height*(0.55),
          width: MediaQuery.of(context).size.width*(0.75),
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 41, 43, 50),
            border: Border.all(width: 1, color: Colors.blue[200]),
          ),
          child:
          isLoading ? Container(
            alignment: Alignment.center,
              child: CircularProgressIndicator(backgroundColor: Colors.transparent,valueColor: AlwaysStoppedAnimation<Color>(Colors.white60),),
          )
          : 
          upcomingEvents
        ),
      ],
    );
  }
}