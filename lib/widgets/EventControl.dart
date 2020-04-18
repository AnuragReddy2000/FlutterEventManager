import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/widgets/ControlButton.dart';

class EventControl extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*(0.55),
      decoration: BoxDecoration(
        color: Color.fromARGB(150, 41, 43, 50),
          border: Border(
            bottom: BorderSide(color: Colors.blue[200],  width: 1.0,),
            top: BorderSide(color: Colors.blue[200],  width: 1.0,),
            left: BorderSide(color: Colors.blue[200], width: 1.0, ),
          )
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
        Expanded(
          child:ControlButton(icon: Icons.add_alarm,text: 'Add Reminder',)
        ),
        Expanded(
          child:ControlButton(icon: Icons.announcement,text: 'Silent Reminder',)
        ),
        Expanded(
          child: ControlButton(icon: Icons.history,text: 'Repeating Reminder',) 
        ),
        Expanded(
          child: ControlButton(icon: Icons.create,text: 'Add New Note',)
        ),
      ],
    ),
    );
  }
} 