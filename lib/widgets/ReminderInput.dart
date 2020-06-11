import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ReminderInput{
  static final _formKey = GlobalKey<FormState>();

  static void reminderInput(BuildContext context,String type,Function saveEvent) async {
    await showDialog(context: context,
      builder: (context) {
        bool isTimeset = false;
        String remindertext;
        String repeatinterval = null;
        DateTime remindertime = null;
        return StatefulBuilder(
          builder: (context,setState){
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 23, 30, 39),
              title: Text('Add '+ ((type == 'ring') ? 'New': type) + ' Reminder',
                style: TextStyle(fontSize: 22, color: Colors.blue[200],),
              ),
              content: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child:Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top:5),
                        alignment: Alignment.centerLeft,
                        child: Text('Reminder Text: ',style: TextStyle(fontSize: 20, color: Colors.white,),),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:5,bottom:5),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ) 
                            ),
                            errorStyle: TextStyle(color: Colors.red),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white
                              ) 
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSaved: (value) => remindertext = value,
                          validator: (value) => value.isEmpty ? 'This field must be filled' : null,
                        ),
                      ),
                      (type == 'Repeating') ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child: Text('Set Repeat Interval:   ',style: TextStyle(fontSize: 14, color: Colors.white,),textAlign: TextAlign.left,),),
                          Theme(
                            data: Theme.of(context).copyWith(canvasColor: Color.fromARGB(255, 23, 30, 39)),
                            child:  DropdownButtonHideUnderline(
                              child: DropdownButton(
                                iconSize: 30,
                                iconEnabledColor: Colors.white,
                                style: TextStyle(color: Colors.blue[200],),
                                items:['Daily','Weekly','Monthly'].map((String value) {
                                  return new DropdownMenuItem<String>(value: value,child: new  Text(value, textAlign: TextAlign.end,));}).toList(), 
                                value: repeatinterval,
                                onChanged: (newValue) {
                                  setState(() {
                                    repeatinterval = newValue;
                                  });
                                },
                              ),
                            )
                          ),
                        ],
                      )
                      : 
                      Container(),
                      isTimeset ? Wrap(
                        children: <Widget>[
                          Text('Remind on:  ',
                            style: TextStyle( color: Colors.white,fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                          Text(DateFormat.E().format(remindertime) +' '+ DateFormat('dd-MM-yyyy').format(remindertime) +' at '+ DateFormat.jm().format(remindertime),
                            style: TextStyle( color: Colors.blue[200],fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      )
                      : 
                      Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(isTimeset ? ' ' : 'Select Reminder time: ',style: TextStyle(fontSize: 14, color: Colors.white,),),
                          Spacer(),
                          FlatButton(child: Text(isTimeset ? 'Change time' : '   Set time',style: TextStyle(color: Colors.blue[200]),textAlign: TextAlign.right,),
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                              DatePicker.showDateTimePicker(context,
                                theme: DatePickerTheme(
                                  backgroundColor: Color.fromARGB(255, 23, 30, 39),
                                  headerColor: Color.fromARGB(255, 23, 30, 39),
                                  itemStyle: TextStyle(color: Colors.white),
                                  doneStyle: TextStyle(color: Colors.blue[200]),
                                  cancelStyle: TextStyle(color: Colors.blue[200]),
                                ),
                                showTitleActions: true,
                                minTime: DateTime.now().add(Duration(minutes: 2)),
                                maxTime: DateTime.now().add(Duration(days: 90)),
                                onConfirm: (datetime) => {remindertime = datetime, setState((){isTimeset = true;})},
                              );
                            },
                          ),
                        ],
                      ), 
                    ],
                  )
                ),
              ),
              actions: <Widget>[
                FlatButton(child: Text('Add Reminder',style: TextStyle(color: Colors.blue[200],)),
                  onPressed: (){
                    if (_formKey.currentState.validate()){
                      if(remindertime != null){
                        if(type == 'Repeating' && repeatinterval == null){
                          Fluttertoast.showToast(msg: 'Select a repeat interval!',
                            backgroundColor: Color.fromARGB(255, 23, 30, 39),
                          );
                        }
                        else{
                          _formKey.currentState.save();
                          saveEvent([remindertext,DateFormat('yyyy-MM-dd').format(remindertime),DateFormat.Hms().format(remindertime),(type == 'Silent' ? 'true':'false'),(type == 'Repeating' ? repeatinterval : 'false')]);
                          Navigator.pop(context);
                        }
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Select a time!',
                          backgroundColor: Color.fromARGB(255, 23, 30, 39),
                        );
                      }
                    }
                  },
                ),
                FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('Back',style: TextStyle(color: Colors.blue[200],))),
              ],
            );
          }
        );
      }, 
      barrierDismissible: false
    );
  }
}





                          