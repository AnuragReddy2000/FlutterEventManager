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
            val pm = context.packageManager
            val launchIntent = pm.getLaunchIntentForPackage("com.example.virtual_event_manager")
            val data = newintent.extras
            if(data!!["Repeat"]!!.toString() != "false" && data["Repeat"]!!.toString() != "snooze"){
                Log.d("Repeat",data["Repeat"]!!.toString())
                setRepeatAlarm(data,context)
            }
            data.putString("route","reminder")
            launchIntent!!.putExtras(data)
            launchIntent.setAction(Intent.ACTION_MAIN)
            launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
            launchIntent.addCategory(Intent.CATEGORY_LAUNCHER)
            context.startActivity(launchIntent)
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
            return datetime.time.toString()
        }
    }

}