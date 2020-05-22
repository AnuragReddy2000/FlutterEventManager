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
        super.onNewIntent(intent)
        val channel = MethodChannel(flutterEngine!!.dartExecutor,CHANNEL)
        val data = intent.extras
        Log.d("before","check")
        val channelargs = mapOf<String,String>("Id" to data!!["Id"]!!.toString(),"Text" to data["Text"]!!.toString(),"Date" to data["Date"]!!.toString(),"Time" to data["Time"]!!.toString(),"Silent" to data["Silent"]!!.toString(),"Repeat" to data["Repeat"]!!.toString())
        channel.invokeMethod("showReminder(call)", channelargs)
        Log.d("after","check")
    }

    private fun snooze(call: MethodCall){
        val intent = Intent("com.example.virtual_event_manager.RING")
        intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent",call.argument<String>("Silent"))
        if(call.argument<String>("Repeat")  != "false"){
            intent.putExtra("Repeat","snooze")
        }
        else{
            intent.putExtra("Repeat","false")
        }
        val id = call.argument<String>("Id")
        val pendingintent = PendingIntent.getBroadcast(context,id!!.toInt(),intent,0)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        var time = getTime(call.argument<String>("Date")!!,call.argument<String>("Time")!!).toLong()
        time += 300000
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,time,pendingintent)
    }

    private fun cancelAlarm(call: MethodCall) {
        val intent = Intent("com.example.virtual_event_manager.RING")
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
        return intentdata["Id"]!!.toString() + "," + intentdata["Text"]!!.toString() +","+ intentdata["Date"]!!.toString() +","+ intentdata["Time"]!!.toString() +","+ intentdata["Silent"]!!.toString() +","+ intentdata["Repeat"]!!.toString()
    }

    private fun sendNotification(call: MethodCall){
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }
        intent.putExtra("Id",call.argument<String>("Id"))
        intent.putExtra("Text",call.argument<String>("Text"))
        intent.putExtra("Date",call.argument<String>("Date"))
        intent.putExtra("Time",call.argument<String>("Time"))
        intent.putExtra("Silent","true")
        intent.putExtra("Repeat",call.argument<String>("Repeat"))
        intent.putExtra("route","reminder")
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)
        val nbuilder = NotificationCompat.Builder(this,getString(R.string.CHANNEL_ID))
                .setSmallIcon(R.drawable.ic_announcement)
                .setContentTitle("Reminder")
                .setContentText(intent.getStringExtra("Text"))
                .setStyle(NotificationCompat.BigTextStyle().bigText("Reminder Date and Time: " + intent.getStringExtra("Date") + " & " + intent.getStringExtra("Time")).setBigContentTitle(intent.getStringExtra("Text")))
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setLargeIcon((getDrawable(R.mipmap.appicon) as BitmapDrawable).bitmap)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
        val id = intent.getStringExtra("Id")
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

    override fun onReceive(context: Context?, intent: Intent?) {
        val pm = context!!.packageManager
        val launchIntent = pm.getLaunchIntentForPackage("com.example.virtual_event_manager")
        var data = intent!!.extras
        if(data!!["Repeat"] != "false" && data["Repeat"] != "snooze"){
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
        val db = DatabaseHelper(context)
        db.update(nextdate,nexttime,id)
        intent.putExtras(intentdata)
        val pendingintent = PendingIntent.getBroadcast(context,id.toInt(),intent,0)
        val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        manager.setExactAndAllowWhileIdle(RTC_WAKEUP,alarmtime,pendingintent)
        db.close()
    }

    @SuppressLint("SimpleDateFormat")
    private fun getTime(date: String, time: String): String{
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        val datetime = sdf.parse(date +  "T" + time)
        return datetime.time.toString()
    }

}