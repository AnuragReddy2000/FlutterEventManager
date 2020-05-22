import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_manager/models/EventsModel.dart';

class UpcomingEvents extends StatelessWidget{

  @override 
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
          Consumer<EventsModel>(
            builder: (context,myEventsModel,child){
              return myEventsModel.isLoading ? Container(
                alignment: Alignment.center,
                child:  Text('Please wait...',
                  style: TextStyle(fontSize: 18, color: Colors.white54),
                  textAlign: TextAlign.center,
                )
              )
              : 
              myEventsModel.upcomingevents;
            },
          )
        ),
      ],
    );
  }  
}

