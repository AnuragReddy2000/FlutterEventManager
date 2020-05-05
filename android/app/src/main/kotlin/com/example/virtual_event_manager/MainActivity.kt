package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.AlarmManager.RTC_WAKEUP
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import java.text.SimpleDateFormat


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.virtual_event_manager.platform_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        val channel = MethodChannel(flutterEngine?.getDartExecutor(),CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if(call.method == "setAlarm(call)"){
                val message = setAlarm(call)
                result.success(message)
            }else{
                result.notImplemented()
            }
        }
    }

    private fun setAlarm(call: MethodCall): String {
        val intent = Intent("com.example.virtual_event_manager.RING")
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("CallBack",call.argument<Long>("CallBack"))
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,0)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val time = getTime(call.argument<String>("Date")!!,call.argument<String>("Time")!!)
        manager.setExact(RTC_WAKEUP,time.toLong(),pendingintent)
        return time
    }

    @SuppressLint("SimpleDateFormat")
    private fun getTime(date: String, time: String): String{
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        val datetime = sdf.parse(date +  "T" + time)
        return datetime.time.toString()
    }
}

class MyReceiver: BroadcastReceiver() {
    private val CHANNEL = "com.example.virtual_event_manager.platform_channel.return"

    override fun onReceive(context: Context?, intent: Intent?) {
        Toast.makeText(context, "brodcast recieved!!!", Toast.LENGTH_LONG).show()
        val pm = context!!.packageManager
        val launchIntent = pm.getLaunchIntentForPackage("com.example.virtual_event_manager")
        launchIntent!!.putExtra("some_data", "value")
        context.startActivity(launchIntent)
        /*val handler = Handler(context!!.mainLooper)
        val runner = Runnable {
            val engine = FlutterEngine(context)
            val callbackHandle = intent!!.extras?.getLong("CallBack")
            val appBundlePath = FlutterMain.findAppBundlePath()
            val assets = context.assets
            val flutterCallback = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle!!)
            val executor: DartExecutor = engine.dartExecutor
            val dartCallback = DartExecutor.DartCallback(assets, appBundlePath, flutterCallback)
            executor.executeDartCallback(dartCallback);

            val channel = MethodChannel(engine.dartExecutor,CHANNEL)
            channel.invokeMethod("ring",null, object: MethodChannel.Result {
                override fun success(o: Any?) {
                    Toast.makeText(context, "ohssaa", Toast.LENGTH_LONG).show()
                }
                override fun error(s1: String, s2: String?, o: Any?) {

                }
                override fun notImplemented() {

                }
            })
        }
        handler.post(runner)*/
    }
}
