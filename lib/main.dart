import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/widgets/UpcomingEvents.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBQueries().insertRow(['Meeting at 10','2020-04-18','10:30:00','false','false']);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 30, 39),
      appBar: AppBar(
        title: Text('Event Manager',
          style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 25, color: Colors.white)),
        ),
        backgroundColor: Color.fromARGB(150, 41, 43, 50),
      ),
      body: Column(
        children: <Widget>[
          UpcomingEvents(),
          Expanded(
            child:Container(
              decoration: BoxDecoration(
            color: Color.fromARGB(150, 41, 43, 50),
            border: Border.all(width: 1, color: Colors.blue[200]),
            ),  
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            width: double.infinity,
            child: Text('Notes: ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),textAlign: TextAlign.center,),
          ), 
          )
        ],
      ),
    );
  }
}

