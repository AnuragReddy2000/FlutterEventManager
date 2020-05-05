import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';
import 'package:virtual_event_manager/widgets/NotesCarousel.dart';

class Notes extends StatefulWidget{

  @override 
  NotesState createState() => NotesState();
}

class NotesState extends State<Notes>{
  bool isLoading = true;
  List<List<String>> inp;

  void getData() async {
    isLoading = true;
    inp= await DBQueries.getNotes();
    setState(() => {
      isLoading = false,
    });
  } 

  @override 
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(150, 41, 43, 50),
        border: Border(top: BorderSide(width: 1, color: Colors.blue[200])),
      ),  
      margin: EdgeInsets.only(top:10),
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Notes: ',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),textAlign: TextAlign.center,),
          isLoading ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height)*0.09),
            child: CircularProgressIndicator(backgroundColor: Colors.transparent,valueColor: AlwaysStoppedAnimation<Color>(Colors.white60),),
          )
          : 
          ((inp.length == 0) ? Text('You haven\'t written any!',style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 18, color: Colors.white54)),textAlign: TextAlign.center,)
            :
            Expanded(child: NotesCarousel(input: inp,onDelete: getData,))
          )
        ],
      ),
    );
  }
}