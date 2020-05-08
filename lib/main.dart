import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/models/EventsModel.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/widgets/AlertPage.dart';
import 'package:virtual_event_manager/widgets/EventControl.dart';
import 'package:virtual_event_manager/widgets/Notes.dart';
import 'package:virtual_event_manager/widgets/UpcomingEvents.dart';

import 'models/NotesModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/reminder': (context) => AlertPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventsModel()
        ),
        ChangeNotifierProvider(
          create: (context) => NotesModel()
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        appBar: AppBar(
          title: Text('Event Manager',
            style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 25, color: Colors.white)),
          ),
          backgroundColor: Color.fromARGB(150, 41, 43, 50),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text('Upcoming Events: ',
                style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              children: <Widget>[
                UpcomingEvents(),
                Expanded(child: EventControl()),
              ],
            ),
            Expanded(
              child: Notes(),
            )
          ],
        ),
      ),
    );
  }
}

