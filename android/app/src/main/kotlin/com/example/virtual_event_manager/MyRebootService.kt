package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.app.job.JobParameters
import android.app.job.JobService
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.text.SimpleDateFormat
import java.util.*

class MyRebootService() : JobService() {

    @SuppressLint("SimpleDateFormat")
    override fun onStartJob(params: JobParameters?): Boolean {
        val db = DatabaseHelper(this)
        val rem = db.getEvents()
        val presenttime = System.currentTimeMillis()
        if(rem.isNotEmpty()){
            val groupbuilder = NotificationCompat.Builder(this,getString(R.string.CHANNEL_ID))
                    .setSmallIcon(R.mipmap.ic_stat_em_1)
                    .setContentText("Missed Reminders")
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setGroupSummary(true)
                    .setGroup("Missed_Reminders")
                    .setAutoCancel(true)
            with(NotificationManagerCompat.from(this)) {
                notify(25041997, groupbuilder.build())
            }
            for(event in rem){
                val time = getTime(event[2],event[3]).toLong()
                if(time > presenttime){
                    val intent = Intent("com.example.virtual_event_manager.RING")
                    intent.putExtra("Id",event[0])
                    intent.putExtra("Text",event[1])
                    intent.putExtra("Date",event[2])
                    intent.putExtra("Time",event[3])
                    intent.putExtra("Silent",event[4])
                    intent.putExtra("Repeat",event[5])
                    intent.flags = Intent.FLAG_RECEIVER_FOREGROUND
                    val id = event[0]
                    val pendingintent = PendingIntent.getBroadcast(this,id.toInt(),intent,PendingIntent.FLAG_ONE_SHOT)
                    val manager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                    manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,time,pendingintent)
                }
                else{
                    val intent = Intent(this, MainActivity::class.java).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                    }
                    val id = event[0]
                    intent.putExtra("Id",event[0])
                    intent.putExtra("Text",event[1])
                    intent.putExtra("Date",event[2])
                    intent.putExtra("Time",event[3])
                    intent.putExtra("Silent","true")
                    intent.putExtra("Repeat","false")
                    intent.putExtra("route","reminder")
                    val pendingIntent: PendingIntent = PendingIntent.getActivity(this, id.toInt(), intent, 0)
                    val nbuilder = NotificationCompat.Builder(this,getString(R.string.CHANNEL_ID))
                            .setSmallIcon(R.mipmap.ic_stat_em_1)
                            .setContentTitle("Missed Reminder")
                            .setContentText("Missed Reminder: " + intent.getStringExtra("Text"))
                            .setStyle(NotificationCompat.BigTextStyle().bigText("Reminder Date and Time: " + intent.getStringExtra("Date") + " & " + intent.getStringExtra("Time")).setBigContentTitle(intent.getStringExtra("Text")))
                            .setPriority(NotificationCompat.PRIORITY_MAX)
                            .setContentIntent(pendingIntent)
                            .setGroup("Missed_Reminders")
                            .setAutoCancel(true)
                    with(NotificationManagerCompat.from(this)) {
                        notify(id.toInt(), nbuilder.build())
                    }
                    if(event[5] != "false" && event[5] != "snooze"){
                        var interval: Long = 0
                        if(event[5] == "Daily"){
                            interval = 86400000
                        }else if(event[5] == "Weekly"){
                            interval = 604800000
                        }else if(event[5] == "Monthly"){
                            interval= 2629800000
                        }
                        val count: Long = (presenttime-time + 300000 + interval - 1)/interval
                        val newtime = time + count*interval
                        val calendar = Calendar.getInstance()
                        calendar.timeInMillis = newtime
                        val nextdate = SimpleDateFormat("yyyy-MM-dd").format(calendar.time)
                        val nexttime = SimpleDateFormat("HH:mm:ss").format(calendar.time)
                        db.update(nextdate,nexttime,id)
                        intent.putExtra("Id",id)
                        intent.putExtra("Text",event[1])
                        intent.putExtra("Date",nextdate)
                        intent.putExtra("Time",nexttime)
                        intent.putExtra("Silent",event[4])
                        intent.putExtra("Repeat",event[5])
                        intent.flags = Intent.FLAG_RECEIVER_FOREGROUND
                        val pendingintent = PendingIntent.getBroadcast(this,id.toInt(),intent,PendingIntent.FLAG_ONE_SHOT)
                        val manager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,newtime,pendingintent)
                    } else if (event[5] == "false"){
                        db.delete(event[0])
                    }
                }
            }
        }
        db.close()
        return false
    }

    override fun onStopJob(params: JobParameters?): Boolean {
        return false
    }

    @SuppressLint("SimpleDateFormat")
    private fun getTime(date: String, time: String): String{
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        val datetime = sdf.parse(date +  "T" + time)
        return datetime.time.toString()
    }
}