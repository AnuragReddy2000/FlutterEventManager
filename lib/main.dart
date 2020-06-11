import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_manager/models/EventsModel.dart';
import 'package:virtual_event_manager/utilities/ChannelTasks.dart';
import 'package:virtual_event_manager/widgets/EventControl.dart';
import 'package:virtual_event_manager/widgets/Notes.dart';
import 'package:virtual_event_manager/widgets/Reminder.dart';
import 'package:virtual_event_manager/widgets/UpcomingEvents.dart';

import 'models/NotesModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventsModel()
        ),
        ChangeNotifierProvider(
          create: (context) => NotesModel()
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          'reminder': (context) => MyHomePage(mode: 'Reminder')
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'QuickSand',
        ),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String mode;
  MyHomePage({Key key,this.mode = 'Normal'}) : super(key: key);

  @override 
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(widget.mode == 'Reminder'){
        List<String> details = await ChannelTasks.getReminderData();
        Reminder.showReminder(context, details,Provider.of<EventsModel>(context,listen: false));
      }
      MethodChannel channel = MethodChannel('com.example.virtual_event_manager.platform_channel');
      channel.setMethodCallHandler((MethodCall call) async {
        if(call.method == 'showReminder(call)'){
          showReminder(call);
        }
      });
    });
  }

  void showReminder(MethodCall call){
    dynamic details =  call.arguments;
    Reminder.showReminder(context, [details["Id"],details["Text"],details["Date"],details["Time"],details["Silent"],details["Repeat"],details["Type"]],Provider.of<EventsModel>(context,listen: false));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 23, 30, 39),
        appBar: AppBar(
          title: Text('Event Manager',
            style:  TextStyle(fontSize: 25, color: Colors.white),
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
                style: TextStyle(fontSize: 20, color: Colors.white,),
                textAlign: TextAlign.left,
              ),
            ),
            Flexible(
              flex: 13,
              child: Row(
                children: <Widget>[
                  UpcomingEvents(),
                  Expanded(child: EventControl()),
                ],
              ),
            ),
            Flexible(
              flex: 7,
              child: Notes(),
            )
          ],
        ),
      );
  }
}


 
