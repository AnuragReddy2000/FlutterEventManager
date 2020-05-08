import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 30, 39),
      body: Container(
        alignment: Alignment.center,
        child: Text('alarm time!!',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}