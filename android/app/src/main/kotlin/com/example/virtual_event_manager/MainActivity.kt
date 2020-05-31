package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.*
import android.app.AlarmManager.RTC_WAKEUP
import android.content.Context
import android.content.Intent
import android.graphics.drawable.BitmapDrawable
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import android.widget.Toast
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterMain
import java.text.SimpleDateFormat


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.virtual_event_manager.platform_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        FlutterMain.startInitialization(this);
        super.onCreate(savedInstanceState)
        val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            km.requestDismissKeyguard(this, null)
        }
        else{
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        }
        createNotificationChannel()
        val channel = MethodChannel(flutterEngine!!.dartExecutor,CHANNEL)
        val intentdata = intent.extras
        channel.setMethodCallHandler { call, result ->
            if(call.method == "setAlarm(call)") {
                val message = setAlarm(call)
                result.success(message)
            }else if(call.method == "getReminderDetails(intentdata)"){
                if(intentdata != null){
                    if(intentdata.containsKey("route")){
                        if(intentdata["route"] == "reminder"){
                            val message = getReminderDetails(intentdata)
                            result.success(message)
                        }
                    }
                    else{
                        result.success("Unable to find reminder data")
                    }
                }
            }else if(call.method == "sendNotification(call)") {
                sendNotification(call)
                result.success("Success")
            }else if(call.method == "cancelAlarm(call)"){
                cancelAlarm(call)
            }else if(call.method == "snooze(call)"){
                snooze(call)
            }else{
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        Log.d("case","onNewIntent")
        super.onNewIntent(intent)
        val channel = MethodChannel(flutterEngine!!.dartExecutor,CHANNEL)
        val data = intent.extras
        if(data!!["route"]!!.toString() == "reminder"){
            val channelargs = mapOf<String,String>("Id" to data["Id"]!!.toString(),"Text" to data["Text"]!!.toString(),"Date" to data["Date"]!!.toString(),"Time" to data["Time"]!!.toString(),"Silent" to data["Silent"]!!.toString(),"Repeat" to data["Repeat"]!!.toString())
            channel.invokeMethod("showReminder(call)", channelargs)
        }
    }

    private fun snooze(call: MethodCall){
        val intent = Intent(context,MyReceiver::class.java)
        intent.action = "com.example.virtual_event_manager.RING"
        intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent",call.argument<String>("Silent"))
        intent.putExtra("Repeat","snooze")
        intent.flags = Intent.FLAG_RECEIVER_FOREGROUND
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,PendingIntent.FLAG_ONE_SHOT)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        var time = getTime(call.argument<String>("Date")!!,call.argument<String>("Time")!!).toLong()
        time += 300000
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,time,pendingintent)
    }

    private fun cancelAlarm(call: MethodCall) {
        val intent = Intent(context,MyReceiver::class.java)
        intent.action = "com.example.virtual_event_manager.RING"
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,PendingIntent.FLAG_ONE_SHOT)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        manager.cancel(pendingintent)
        Toast.makeText(getApplicationContext(),"Reminder Cancelled", Toast.LENGTH_SHORT).show();
    }

    private fun setAlarm(call: MethodCall): String {
        val intent = Intent(context,MyReceiver::class.java)
        intent.action = "com.example.virtual_event_manager.RING"
        intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent",call.argument<String>("Silent"))
        intent.putExtra("Repeat",call.argument<String>("Repeat"))
        intent.flags = Intent.FLAG_RECEIVER_FOREGROUND
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,PendingIntent.FLAG_ONE_SHOT)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val time = getTime(call.argument<String>("Date")!!,call.argument<String>("Time")!!)
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,time.toLong(),pendingintent)
        Toast.makeText(getApplicationContext(),"Reminder Set", Toast.LENGTH_SHORT).show();
        return time
    }

    private fun getReminderDetails(intentdata: Bundle): String{
        return intentdata["Id"]!!.toString() + "," + intentdata["Text"]!!.toString() +","+ intentdata["Date"]!!.toString() +","+ intentdata["Time"]!!.toString() +","+ intentdata["Silent"]!!.toString() +","+ intentdata["Repeat"]!!.toString()
    }

    private fun sendNotification(call: MethodCall){
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }
        val id = call.argument<String>("Id")
        intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent","true")
        intent.putExtra("Repeat","false")
        intent.putExtra("route","reminder")
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, id!!.toInt(), intent, 0)
        val nbuilder = NotificationCompat.Builder(this,getString(R.string.CHANNEL_ID))
                .setSmallIcon(R.mipmap.ic_stat_em_1)
                .setContentTitle("Reminder")
                .setContentText(intent.getStringExtra("Text"))
                .setStyle(NotificationCompat.BigTextStyle().bigText("Reminder Date and Time: " + intent.getStringExtra("Date") + " & " + intent.getStringExtra("Time")).setBigContentTitle(intent.getStringExtra("Text")))
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
        with(NotificationManagerCompat.from(this)) {
            notify(id.toInt(), nbuilder.build())
        }
    }

    @SuppressLint("SimpleDateFormat")
    private fun getTime(date: String, time: String): String{
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        val datetime = sdf.parse(date +  "T" + time)
        return datetime.time.toString()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.channel_name)
            val descriptionText = getString(R.string.channel_description)
            val CHANNEL_ID = getString(R.string.CHANNEL_ID)
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            channel.enableVibration(true)
            val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val att = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
            val uri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            channel.setSound(uri,att)
            notificationManager.createNotificationChannel(channel)
        }
    }
}
