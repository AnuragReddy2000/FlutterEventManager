import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_event_manager/dataBase/DBQueries.dart';

import '../main.dart';

void handleCallBack(){
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel _channel =  MethodChannel('com.example.virtual_event_manager.platform_channel.return');
  _channel.setMethodCallHandler((MethodCall call) async {
    if(call.method == 'ring'){
      ring();
      return Future.value("success");
    }
  });
}

void ring(){
  print("It is ringing");
}

class ChannelTasks {

  static const MethodChannel channel = MethodChannel('com.example.virtual_event_manager.platform_channel');
  static final CallbackHandle handle = PluginUtilities.getCallbackHandle(handleCallBack);

  static void setAlarm(List<String> inp) async {
    String res = await channel.invokeMethod('setAlarm(call)',input(inp));
    print(res);
  }

  static Map<String,dynamic> input(List<String> inp){
    Map<String, dynamic> args = <String, dynamic>{};
    args['Id'] = inp[0];
    args['Text'] = inp[1];
    args['Date'] = inp[2];
    args['Time'] = inp[3];
    args['Silent'] = inp[4];
    args['Repeat'] = inp[5];
    args['CallBack'] = handle.toRawHandle();
    return args;
  }

}

/*void show(BuildContext context) async {
        OverlayState overlayState = Overlay.of(context);
        OverlayEntry overlayEntry = new OverlayEntry(builder: _build);

        overlayState.insert(overlayEntry);

        await new Future.delayed(const Duration(seconds: 2));

        overlayEntry.remove();
    }

    Widget _build(BuildContext context){
      return new Positioned(
        top: 50.0,
        left: 50.0,
        child: new Material(
            color: Colors.transparent,
            child: new Icon(Icons.warning, color: Colors.purple),
        ),
      );
    }*/