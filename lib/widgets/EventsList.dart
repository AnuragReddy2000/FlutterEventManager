import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/utilities/DateSupport.dart';
import 'AlertPopUp.dart';

class EventsList extends StatelessWidget{
  final List<String> inp;
  final Function callBack;
  EventsList({this.inp,this.callBack});

  @override 
  Widget build(BuildContext context){
    return InkWell(
      onTap: (){AlertPopUp.alertBox(context,inp,'view',callBack);},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Color.fromARGB(255, 23, 30, 39),
        ),
        margin: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5,left: 5, right: 10,bottom: 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red[900],
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      padding: EdgeInsets.only(left: 5,right: 3,top: 3,bottom: 3),
                      child: Text( DateSupport.getTime(inp),
                        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Text( DateSupport.getDay(inp),
                      style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 12, color: Colors.blue[200],)),
                    ),
                    Text(DateSupport.getdate(inp),
                      style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 12, color: Colors.blue[200],)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.white, width: 1.0, ),),
                  ),
                  child: Text(inp[1],
                    style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 16, color: Colors.white,)),
                    textAlign: TextAlign.center,
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}