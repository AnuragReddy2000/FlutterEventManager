import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlButton extends StatelessWidget{
  final IconData icon;
  final String text;
  final Function ontap;
  ControlButton({this.icon,this.text,this.ontap});

  @override 
  Widget build(BuildContext context){
    return InkWell(
      onTap: (){ontap(context);},
      child:Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
        padding: EdgeInsets.all(5),
        child: FittedBox(child: Icon(icon,color: Colors.blue[200],), fit: BoxFit.fitWidth)
        ),
        ),
        Container(
          padding: EdgeInsets.only(left:5,right: 5),
          child: Text(text,style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 12, color: Colors.blue[200])),textAlign: TextAlign.center,),
        )
        ],
      ),
      ),
    );
  }
}