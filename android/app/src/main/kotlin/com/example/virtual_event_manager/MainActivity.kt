package com.example.virtual_event_manager

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.flutter.event.alarm"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        MethodChannel(flutterEngine?.getDartExecutor(),CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "setAlarm"){
                val message = setAlarm()
                result.success(message)
            }else{
                result.notImplemented()
            }
        }
    }

    private fun setAlarm(): String {
        return "alarm set!!"
    }
}
