package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.*
import android.app.AlarmManager.RTC_WAKEUP
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.drawable.BitmapDrawable
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.widget.Toast
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterMain
import java.text.SimpleDateFormat
import java.util.*


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
            }else if(call.method == "sendNotification(intentdata)") {
                if (intentdata != null) {
                    if (intentdata.containsKey("route")) {
                        if (intentdata["route"] == "reminder") {
                            sendNotification(intentdata)
                            result.success("Success")
                        }
                    } else {
                        result.success("Unable to send notification")
                    }
                }
            }else if(call.method == "cancelAlarm(call)"){
                cancelAlarm(call)
            }
            else{
                result.notImplemented()
            }
        }
    }

    private fun cancelAlarm(call: MethodCall) {
        val intent = Intent("com.example.virtual_event_manager.RING")
        /*intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent",call.argument<String>("Silent"))
        intent.putExtra("Repeat",call.argument<String>("Repeat"))*/
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,0)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        manager.cancel(pendingintent)
        Toast.makeText(getApplicationContext(),"Reminder Cancelled", Toast.LENGTH_SHORT).show();
    }

    private fun setAlarm(call: MethodCall): String {
        val intent = Intent("com.example.virtual_event_manager.RING")
        intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent",call.argument<String>("Silent"))
        intent.putExtra("Repeat",call.argument<String>("Repeat"))
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,0)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val time = getTime(call.argument<String>("Date")!!,call.argument<String>("Time")!!)
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,time.toLong(),pendingintent)
        Toast.makeText(getApplicationContext(),"Reminder Set", Toast.LENGTH_SHORT).show();
        return time
    }

    private fun getReminderDetails(intentdata: Bundle): String{
        return intentdata["Text"]!!.toString() +","+ intentdata["Date"]!!.toString() +","+ intentdata["Time"]!!.toString() +","+ intentdata["Silent"]!!.toString()
    }

    private fun sendNotification(intentdata: Bundle){
        val CHANNEL_ID = getString(R.string.CHANNEL_ID)
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }
        intentdata.putString("Silent","true")
        intent.putExtras(intentdata)
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)
        val nbuilder = NotificationCompat.Builder(this,CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_announcement)
                .setContentTitle("Reminder")
                .setContentText(intentdata["Text"]!!.toString())
                .setStyle(NotificationCompat.BigTextStyle().bigText("Reminder Time: " + intentdata["Time"]!!.toString() + " Reminder Date: " + intentdata["Date"]!!.toString()).setBigContentTitle(intentdata["Text"]!!.toString()))
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setLargeIcon((getDrawable(R.mipmap.appicon) as BitmapDrawable).bitmap)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
        val id = intentdata["Id"]!!.toString()
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

class MyReceiver: BroadcastReceiver() {
    private val CHANNEL = "com.example.virtual_event_manager.platform_channel.return"

    override fun onReceive(context: Context?, intent: Intent?) {
        val pm = context!!.packageManager
        val launchIntent = pm.getLaunchIntentForPackage("com.example.virtual_event_manager")
        var data = intent!!.extras
        if(data!!["Repeat"] != "false"){
            setRepeatAlarm(data,context)
        }
        data.putString("route","reminder")
        launchIntent!!.putExtras(data)
        launchIntent.setAction(Intent.ACTION_MAIN)
        launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        launchIntent.addCategory(Intent.CATEGORY_LAUNCHER)
        context.startActivity(launchIntent)
    }

    @SuppressLint("SimpleDateFormat")
    private fun setRepeatAlarm(intentdata: Bundle, context: Context){
        val intent = Intent("com.example.virtual_event_manager.RING")
        val id = intentdata["Id"]!!.toString()
        var alarmtime = getTime(intentdata["Date"]!!.toString(),intentdata["Time"]!!.toString()).toLong()
        if(intentdata["Repeat"] == "Daily"){
            alarmtime += 86400000
        }else if (intentdata["Repeat"] == "Weekly"){
            alarmtime += 604800000
        }else if(intentdata["Repeat"] == "Monthly"){
            alarmtime += 2629800000
        }
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = alarmtime
        val nextdate = SimpleDateFormat("yyyy-MM-dd").format(calendar.time)
        val nexttime = SimpleDateFormat("HH:mm:ss").format(calendar.time)
        intentdata.putString("Date",nextdate)
        intentdata.putString("Time",nexttime)
        intent.putExtras(intentdata)
        val pendingintent = PendingIntent.getBroadcast(context,id.toInt(),intent,0)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,alarmtime,pendingintent)
    }

    @SuppressLint("SimpleDateFormat")
    private fun getTime(date: String, time: String): String{
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        val datetime = sdf.parse(date +  "T" + time)
        return datetime.time.toString()
    }

}