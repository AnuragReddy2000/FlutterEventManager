import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/widgets/AlertPopUp.dart';

class NotesCarousel extends StatelessWidget{
  final List<List<String>> input;
  final Function onDelete;
  NotesCarousel({this.input,this.onDelete});

  List<Widget> getList(BuildContext context) {
    List<Widget> list = List();
    for(var i=0; i<input.length; i++){
      list.add(InkWell(
        onTap:(){ AlertPopUp.alertBox(context, input[i], 'note', onDelete);},
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 23, 30, 39),
            border: Border.all(width: 1, color: Colors.white),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Text(input[i][1],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 22, color: Colors.blue[200],)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left:5,right:5),
                alignment: Alignment.center,
                child: Text(input[i][2],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                  style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 20, color: Colors.white,)),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      child: Text(input[i][3],
                        textAlign: TextAlign.left,
                        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 16, color: Colors.white54,)),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.centerRight,
                      child: Text(input[i][4],
                        textAlign: TextAlign.right,
                        style: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 16, color: Colors.white54,)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: getList(context),
      options: CarouselOptions(
        viewportFraction: 0.9,
        aspectRatio: 2.0,
        autoPlay: true,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
      ),
    );
  }
}