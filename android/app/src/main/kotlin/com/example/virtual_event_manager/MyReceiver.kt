package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.AsyncTask
import android.os.Bundle
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import java.text.SimpleDateFormat
import java.util.*

class MyReceiver: BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        val pendingResult: PendingResult = goAsync()
        val asynctask = MyTask(pendingResult,intent!!,context!!)
        asynctask.execute()
    }

    private class MyTask(val pendingResult: PendingResult, val newintent: Intent, val context: Context): AsyncTask<String, Int, String>() {

        override fun doInBackground(vararg params: String?): String {
            if(newintent.action == "com.example.virtual_event_manager.RING"){
                val data = newintent.extras
                if(data!!["Repeat"]!!.toString() != "false" && data["Type"]!!.toString() == "Normal"){
                    setRepeatAlarm(data,context)
                }
                val id = data["Id"]!!.toString()
                val serviceIntent = Intent(context,NotificationService::class.java)
                serviceIntent.putExtras(data)
                ContextCompat.startForegroundService(context,serviceIntent)

                val stopIntent = Intent(context,MyReceiver::class.java)
                stopIntent.action = "com.example.virtual_event_manager.notification.channel.STOP"
                stopIntent.addCategory(Intent.CATEGORY_DEFAULT)
                val stopPendingIntent = PendingIntent.getBroadcast(context,id.toInt(),stopIntent,PendingIntent.FLAG_ONE_SHOT)
                val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val time = Date().time + 180000
                manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,time,stopPendingIntent)
            }
            else if(newintent.action == "com.example.virtual_event_manager.notification.channel.RESPONSE_DISMISS"){
                val data = newintent.extras
                val db = DatabaseHelper(context)
                if(data!!["Repeat"]!!.toString() == "false" && data["Type"] == "Normal") {
                    db.delete(data["Id"]!!.toString())
                }
                val serviceIntent = Intent(context,NotificationService::class.java)
                db.close()
                context.stopService(serviceIntent)
            }else if(newintent.action == "com.example.virtual_event_manager.notification.channel.STOP"){
                val serviceIntent = Intent(context,NotificationService::class.java)
                context.stopService(serviceIntent)
            }else if (newintent.action == "com.example.virtual_event_manager.notification.channel.RESPONSE_SNOOZE"){
                val data = newintent.extras
                val db = DatabaseHelper(context)
                if(data!!["Repeat"]!!.toString() == "false" && data["Type"] == "Normal") {
                    db.delete(data["Id"]!!.toString())
                }
                val intent = Intent(context,MyReceiver::class.java)
                intent.action = "com.example.virtual_event_manager.RING"
                intent.putExtra("Id",data["Id"]!!.toString())
                intent.putExtra("Text",data["Text"]!!.toString())
                intent.putExtra("Date",data["Date"]!!.toString())
                intent.putExtra("Time",data["Time"]!!.toString())
                intent.putExtra("Silent",data["Silent"]!!.toString())
                intent.putExtra("Repeat",data["Repeat"]!!.toString())
                intent.putExtra("Type","Snooze")
                intent.addCategory(Intent.CATEGORY_DEFAULT)
                intent.flags = Intent.FLAG_RECEIVER_FOREGROUND
                val id = data["Id"]!!.toString()
                val time = Date().time + 300000
                val pendingintent = PendingIntent.getBroadcast(context,id.toInt(),intent, PendingIntent.FLAG_ONE_SHOT)
                val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,time,pendingintent)
                val serviceIntent = Intent(context,NotificationService::class.java)
                db.close()
                context.stopService(serviceIntent)
            }
            Log.d("Receiver","sent")
            return "Done"
        }

        override fun onPostExecute(result: String?) {
            super.onPostExecute(result)
            pendingResult.finish()
        }

        @SuppressLint("SimpleDateFormat")
        private fun setRepeatAlarm(intentdata: Bundle, context: Context){
            val intent = Intent(context,MyReceiver::class.java)
            intent.action = "com.example.virtual_event_manager.RING"
            val id = intentdata["Id"]!!.toString()
            val oldtime = getTime(intentdata["Date"]!!.toString(),intentdata["Time"]!!.toString()).toLong()
            var alarmtime: Long = 0;
            if(intentdata["Repeat"]!!.toString() == "Daily"){
                alarmtime = 86400000 + oldtime
                Log.d("its_changing",alarmtime.toString())
            }else if (intentdata["Repeat"]!!.toString() == "Weekly"){
                alarmtime = 604800000 + oldtime
            }else if(intentdata["Repeat"]!!.toString() == "Monthly"){
                alarmtime = 2629800000 + oldtime
            }
            Log.d("next time",alarmtime.toString())
            val calendar = Calendar.getInstance()
            calendar.timeInMillis = alarmtime
            val nextdate = SimpleDateFormat("yyyy-MM-dd").format(calendar.time)
            val nexttime = SimpleDateFormat("HH:mm:ss").format(calendar.time)
            Log.d("next datetime",nextdate.toString() + nexttime.toString())
            val db = DatabaseHelper(context)
            db.update(nextdate,nexttime,id)
            intent.putExtra("Id",id)
            intent.putExtra("Text",intentdata["Text"]!!.toString())
            intent.putExtra("Date",nextdate)
            intent.putExtra("Time",nexttime)
            intent.putExtra("Silent",intentdata["Silent"]!!.toString())
            intent.putExtra("Repeat",intentdata["Repeat"]!!.toString())
            intent.putExtra("Type",intentdata["Type"]!!.toString())
            intent.flags = Intent.FLAG_RECEIVER_FOREGROUND
            val pendingintent = PendingIntent.getBroadcast(context,id.toInt(),intent,PendingIntent.FLAG_ONE_SHOT)
            val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,alarmtime,pendingintent)
            db.close()
        }

        @SuppressLint("SimpleDateFormat")
        private fun getTime(date: String, time: String): String{
            val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
            val datetime = sdf.parse(date +  "T" + time)
            return datetime!!.time.toString()
        }
    }

}